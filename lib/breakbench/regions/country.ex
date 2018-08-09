defmodule Breakbench.Regions.Country do
  use Ecto.Schema
  import Ecto.Changeset


  @derive {Phoenix.Param, key: :short_name}
  @primary_key {:short_name, :string, []}
  schema "countries" do
    field :long_name, :string
  end

  @doc false
  def changeset(country, attrs) do
    country
      |> cast(attrs, [:short_name, :long_name])
      |> validate_required([:short_name, :long_name])
  end
end
