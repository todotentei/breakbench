defmodule Breakbench.Stripe.Action do
  @moduledoc false
  alias Breakbench.Repo


  defmacro use_default_action(type, opts \\ []) do
    default(type, opts)
  end

  defmacro use_action(name, args, do: block) do
    quote do
      def unquote(name)(unquote_splicing(args)) do
        unquote(block)
      end
    end
  end


  ## Private

  # Create
  defp default(:create, opts) do
    create_block =
      quote bind_quoted: [opts: opts], unquote: false do
        parse = Keyword.get(opts, :parse, true)
        with {:ok, attrs} <- __MODULE__.request(:post, resource, data, parse: parse),
             {:ok, object} <- struct(__MODULE__.schema())
               |> __MODULE__.schema().changeset(attrs)
               |> Repo.insert()
        do
          {:ok, __MODULE__.associations(object, attrs)}
        else
          error -> error
        end
      end

    class_condition do
      quote do
        use_action :create, [parent_id, data] do
          resource = "#{__MODULE__.path()}/#{parent_id}/#{__MODULE__.subpath()}"
          unquote(create_block)
        end
      end
    else
      quote do
        use_action :create, [data] do
          resource = __MODULE__.path()
          unquote(create_block)
        end
      end
    end
  end

  # Retrieve
  defp default(:retrieve, opts) do
    retrieve_block =
      quote bind_quoted: [opts: opts], unquote: false do
        parse = Keyword.get(opts, :parse, true)
        __MODULE__.request(:get, resource, %{}, parse: parse)
      end

    class_condition do
      quote do
        use_action :retrieve, [parent_id, id] do
          resource = "#{__MODULE__.path()}/#{parent_id}/#{__MODULE__.subpath()}/#{id}"
          unquote(retrieve_block)
        end
      end
    else
      quote do
        use_action :retrieve, [id] do
          resource = "#{__MODULE__.path()}/#{id}"
          unquote(retrieve_block)
        end
      end
    end
  end

  # Update
  defp default(:update, opts) do
    update_block =
      quote bind_quoted: [opts: opts], unquote: false do
        parse = Keyword.get(opts, :parse, true)
        assoc_keys = :belongs_to
          |> __MODULE__.__associations__()
          |> Enum.map(&elem(&1, 1))

        object = Repo.get!(__MODULE__.schema(), id)
        with {:ok, attrs} <- __MODULE__.request(:post, resource, data, parse: parse),
             {:ok, updated} <- object
               |> __MODULE__.schema().changeset(attrs)
               |> Repo.update()
        do
          {:ok, __MODULE__.associations(updated, attrs)}
        else
          error -> error
        end
      end

    class_condition do
      quote do
        use_action :update, [parent_id, id, data] do
          resource = "#{__MODULE__.path()}/#{parent_id}/#{__MODULE__.subpath()}/#{id}"
          unquote(update_block)
        end
      end
    else
      quote do
        use_action :update, [id, data] do
          resource = "#{__MODULE__.path()}/#{id}"
          unquote(update_block)
        end
      end
    end
  end

  # Delete
  defp default(:delete, opts) do
    delete_block =
      quote bind_quoted: [opts: opts], unquote: false do
        parse = Keyword.get(opts, :parse, false)
        case __MODULE__.request(:delete, resource, %{}, parse: parse) do
          {:ok, %{deleted: true, id: id}} ->
            __MODULE__.schema()
              |> Repo.get!(id)
              |> Repo.delete()
          error -> error
        end
      end

    class_condition do
      quote do
        use_action :delete, [parent_id, id] do
          resource = "#{__MODULE__.path()}/#{parent_id}/#{__MODULE__.subpath()}/#{id}"
          unquote(delete_block)
        end
      end
    else
      quote do
        use_action :delete, [id] do
          resource = "#{__MODULE__.path()}/#{id}"
          unquote(delete_block)
        end
      end
    end
  end

  # List
  defp default(:list, opts) do
    list_block =
      quote bind_quoted: [opts: opts], unquote: false do
        config = Application.get_env(:breakbench, Stripe)
        config_list = Keyword.get(config, :list, [])

        lazy_limit = fn -> Keyword.get(config_list, :limit, 10) end
        data = Map.put_new_lazy(data, :limit, lazy_limit)

        parse = Keyword.get(opts, :parse, true)
        __MODULE__.request(:get, resource, data, parse: parse)
      end

    data =
      quote bind_quoted: [opts: opts], unquote: false do
        opts
          |> Keyword.get(:data, %{})
          |> Map.new
      end

    class_condition do
      quote do
        use_action :list, [parent_id, data \\ unquote(data)] do
          resource = "#{__MODULE__.path()}/#{parent_id}/#{__MODULE__.subpath()}"
          unquote(list_block)
        end
      end
    else
      quote do
        use_action :list, [data \\ unquote(data)] do
          resource = __MODULE__.path()
          unquote(list_block)
        end
      end
    end
  end

  defp class_condition(do: dependent_block, else: independent_block) do
    quote do
      cond do
        !is_nil(@path) and !is_nil(@subpath) ->
          unquote(dependent_block)
        !is_nil(@path) ->
          unquote(independent_block)
        true ->
          raise CompileError
      end
    end
  end
end
