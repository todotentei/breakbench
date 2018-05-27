defmodule Breakbench.GeocodeBehaviour do
  @moduledoc false

  defmacro __using__ _ do
    quote do
      Module.register_attribute __MODULE__, :components,
        accumulate: true

      import Breakbench.GeocodeBehaviour

      @before_compile Breakbench.GeocodeBehaviour
    end
  end

  defmacro __before_compile__ _ do
    quote do
      def __components__ do
        Enum.map(@components, &elem(&1, 0))
      end

      @enforce_keys @components
        |> Enum.filter(&elem(&1, 1) == :mandatory)
        |> Enum.map(&elem(&1, 1))
      defstruct Enum.reduce(@components, [],
        fn {module, _}, acc -> [{module.field, nil} | acc] end)

      def get(%__MODULE__{} = geocode, type) do
        Map.fetch!(geocode, type)
      end
    end
  end

  defmacro perform(module, status \\ :optional) do
    quote bind_quoted: [module: module, status: status] do
      Module.put_attribute __MODULE__, :components, {module, status}
    end
  end
end
