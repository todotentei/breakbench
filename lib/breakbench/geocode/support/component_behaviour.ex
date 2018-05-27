defmodule Breakbench.Geocode.ComponentBehaviour do
  @moduledoc false

  defmacro __using__ _ do
    quote do
      @enforce_keys [:short_name, :long_name]
      defstruct [
        short_name: nil, long_name: nil
      ]

      Module.register_attribute __MODULE__, :address_component,
        accumulate: false
      Module.register_attribute __MODULE__, :administrative_divisions,
        accumulate: true

      alias Breakbench.Repo

      import Ecto
      import Ecto.Query
      import Breakbench.Geocode.ComponentBehaviour

      @before_compile Breakbench.Geocode.ComponentBehaviour

      def new(short_name, long_name) do
        struct(__MODULE__, [
          {:short_name, short_name}, {:long_name, long_name}
        ])
      end

      def data(%__MODULE__{} = component) do
        %{short_name: component.short_name, long_name: component.long_name}
      end
    end
  end

  defmacro __before_compile__ _ do
    quote do
      def __address_component__, do: @address_component
      def __administrative_divisions__, do: @administrative_divisions

      def field, do: elem(@address_component, 0)
    end
  end

  defmacro address_component(field, opts \\ []) do
    quote bind_quoted: [field: field, opts: opts] do
      Module.put_attribute __MODULE__, :address_component, {field, opts}
    end
  end

  defmacro belongs_to(field, opts \\ []) do
    quote bind_quoted: [field: field, opts: opts] do
      Module.put_attribute __MODULE__, :administrative_divisions,
        {:belongs_to, field, opts}
    end
  end

  defmacro has_many(field, opts \\ []) do
    quote bind_quoted: [field: field, opts: opts] do
      Module.put_attribute __MODULE__, :administrative_divisions,
        {:has_many, field, opts}
    end
  end
end
