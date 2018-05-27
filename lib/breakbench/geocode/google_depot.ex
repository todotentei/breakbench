defmodule Breakbench.Geocode.GoogleDepot do
  @moduledoc false

  alias Breakbench.{Repo, Geocode}
  alias Breakbench.Geocode.CountryComponent
  alias Breakbench.AddressComponents.Country


  @spec resolve(geocode :: Breakbench.Geocode.Google.t) :: :ok | :error
  def resolve(%Geocode.Google{} = geocode) do
    case geocode
      |> Geocode.Google.get(CountryComponent.field)
      |> CountryComponent.resolve
    do
      {_, %Country{} = country} ->
        resolve_division = fn {_, component, _}, acc ->
          if value = Geocode.Google.get(geocode, component.field) do
            case component.resolve(country, value) do
              {state, data} when state in [:new, :old] ->
                [{state, component, data} | acc]
              _ ->
                acc
            end
          else
            acc
          end
        end
        # Resolve all administrative divisions within the country
        CountryComponent.__administrative_divisions__
          |> Enum.reduce([], resolve_division)
          |> resolve_relations()
        # Return :ok
        :ok
      _ ->
        :error
    end
  end

  ## Private

  defp resolve_relations(resolved_divisions) do
    Enum.each(resolved_divisions, fn
      {:new, component0, data0} ->
        Enum.each(component0.__administrative_divisions__(),
            fn {_, component1, opts} ->
          case Enum.find(resolved_divisions, &elem(&1, 1) == component1) do
            {_, _, data1} ->
              try do
                if conjunction = Keyword.get(opts, :join_through) do
                  struct(conjunction)
                    |> conjunction.changeset(%{})
                    |> Ecto.Changeset.put_assoc(component0.field, data0)
                    |> Ecto.Changeset.put_assoc(component1.field, data1)
                    |> Repo.insert()
                end
              rescue
                _ -> :exist
              end
            _ ->
              nil
          end
        end)
      _ ->
        nil
    end)
  end
end
