defmodule Breakbench.Stripe.Object do
  @doc false
  defmacro __using__ _ do
    quote do
      import Breakbench.Stripe.Object

      Module.register_attribute __MODULE__, :parse_fields, accumulate: true
      Module.register_attribute __MODULE__, :associations, accumulate: true

      @before_compile Breakbench.Stripe.Object


      use GenServer

      @doc false
      def start_link do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
      end

      @impl true
      def init(_), do: {:ok, []}

      @impl true
      def terminate(_reason, _state), do: :ok

      @doc """
      Asynchronous
      """
      def async(attrs) do
        GenServer.cast(__MODULE__, {:async, attrs})
      end

      @doc """
      Synchronous
      """
      def sync(attrs) do
        GenServer.call(__MODULE__, {:sync, attrs})
      end
    end
  end

  defmacro __before_compile__ _ do
    quote do
      def __parse_fields__(), do: @parse_fields

      def __associations__(), do: @associations
      def __associations__(type) do
        mesh = fn {t, _, _, _} -> t == type end
        Enum.filter(@associations, mesh)
      end
      def __associations__(type, index) do
        index_at = fn el -> elem(el, index) end
        Enum.map(__associations__(type), index_at)
      end
    end
  end

  defmacro stripe_object(name) do
    quote do
      def object(), do: unquote(name)
    end
  end

  defmacro stripe(path, subpath \\ nil, schema, do: block) do
    quote do
      Module.put_attribute __MODULE__, :path, unquote(path)
      def path(), do: unquote(path)

      Module.put_attribute __MODULE__, :subpath, unquote(subpath)
      def subpath(), do: unquote(subpath)

      Module.put_attribute __MODULE__, :schema, unquote(schema)
      def schema(), do: unquote(schema)


      import Breakbench.Stripe.Object
      import Breakbench.Stripe.Action
      unquote(block)

      @impl true
      def handle_cast({:async, attrs}, state) do
        resolve(attrs)
        {:noreply, state}
      end

      @impl true
      def handle_call({:sync, attrs}, _from, state) do
        response = resolve(attrs)
        {:reply, response, state}
      end

      def request(method, path, data, opts \\ []) do
        alias Breakbench.Stripe.HTTPClient
        # Parse response by type
        parse_response = fn
          %{object: "list"} = list ->
            update_in list, [:data], fn data ->
              Enum.map(data, &parsing(__MODULE__, &1))
            end
          object ->
            parsing(__MODULE__, object)
        end

        case HTTPClient.request(method, path, data) do
          {:ok, response} ->
            if Keyword.get(opts, :parse, false) do
              {:ok, parse_response.(response)}
            else
              {:ok, response}
            end
          error -> error
        end
      end

      def associations(struct, attrs) do
        Enum.reduce __MODULE__.__associations__(:belongs_to), struct,
          fn {_, field, schema, opts}, acc ->
            if object = Map.get(attrs, field) do
              belongs_to_action(acc, field, schema, object, opts)
            else
              acc
            end
          end
      end


      ## Private

      # If non exists, then sync with remote stripe
      # Else, return local object
      defp resolve(%{id: id} = attrs) do
        alias Breakbench.Repo
        unless object = Repo.get(schema(), id) do
          {:ok, data} = struct(schema())
            |> schema().changeset(attrs)
            |> Repo.insert()
          {:ok, associations(data, attrs)}
        else
          {:ok, object}
        end
      end

      defp belongs_to_action(%{__struct__: schema} = struct,
           field, reference, object, opts) do
        sync? = Keyword.get(opts, :sync, true)
        data = sync_or_get(sync?, reference, object)

        struct
          |> Breakbench.Repo.preload(field)
          |> schema.changeset(%{})
          |> Ecto.Changeset.put_assoc(field, data)
          |> Breakbench.Repo.update!()
      end


      # Sync if true, else get
      defp sync_or_get(true, schema, id) do
        {:ok, object} = schema.retrieve(id)
        {:ok, synced} = schema.sync(object)
        synced
      end

      defp sync_or_get(false, schema, object) do
        Breakbench.Repo.get(schema, object)
      end
    end
  end

  @doc """
  Connect associations with the object by remote synchronization or get from
  local database.
  """
  defmacro belongs_to(field, schema, opts \\ []) do
    quote do
      Module.put_attribute __MODULE__, :associations, {:belongs_to,
        unquote(field), unquote(schema), unquote(opts)}
    end
  end

  @doc """
  Parse field of the response into the correct format for local use.
  """
  defmacro parse_field(field, value, do: block) do
    quote do
      Module.put_attribute __MODULE__, :parse_fields, unquote(field)

      def __parse_field__(unquote_splicing([field, value])) do
        unquote(block)
      end
    end
  end

  def parsing(module, attrs) do
    Enum.reduce module.__parse_fields__(), attrs, fn field, acc ->
      Map.update acc, field, nil, fn value ->
        unless is_nil(value) do
          apply(module, :__parse_field__, [field, value])
        end
      end
    end
  end
end
