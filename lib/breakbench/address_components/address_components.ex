defmodule Breakbench.AddressComponents do
  @moduledoc """
  The AddressComponents context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.AddressComponents.Country

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries do
    Repo.all(Country)
  end

  @doc """
  Gets a single country.

  ## Examples

      iex> get_country(123)
      %Country{}

  """
  def get_country(code) do
    Repo.get(Country, code)
  end

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{source: %Country{}}

  """
  def change_country(%Country{} = country) do
    Country.changeset(country, %{})
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel1

  @doc """
  Returns the list of administrative_area_level_1s.

  ## Examples

      iex> list_administrative_area_level_1s()
      [%AdministrativeAreaLevel1{}, ...]

  """
  def list_administrative_area_level_1s do
    Repo.all(AdministrativeAreaLevel1)
  end

  @doc """
  Gets a single administrative_area_level1.

  ## Examples

      iex> get_administrative_area_level1(123)
      %AdministrativeAreaLevel1{}

  """
  def get_administrative_area_level1(id) do
    Repo.get(AdministrativeAreaLevel1, id)
  end

  @doc """
  Creates a administrative_area_level1.

  ## Examples

      iex> create_administrative_area_level1(%{field: value})
      {:ok, %AdministrativeAreaLevel1{}}

      iex> create_administrative_area_level1(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level1(attrs \\ %{}) do
    %AdministrativeAreaLevel1{}
    |> AdministrativeAreaLevel1.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a administrative_area_level1.

  ## Examples

      iex> update_administrative_area_level1(administrative_area_level1, %{field: new_value})
      {:ok, %AdministrativeAreaLevel1{}}

      iex> update_administrative_area_level1(administrative_area_level1, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_administrative_area_level1(%AdministrativeAreaLevel1{} = administrative_area_level1, attrs) do
    administrative_area_level1
    |> AdministrativeAreaLevel1.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AdministrativeAreaLevel1.

  ## Examples

      iex> delete_administrative_area_level1(administrative_area_level1)
      {:ok, %AdministrativeAreaLevel1{}}

      iex> delete_administrative_area_level1(administrative_area_level1)
      {:error, %Ecto.Changeset{}}

  """
  def delete_administrative_area_level1(%AdministrativeAreaLevel1{} = administrative_area_level1) do
    Repo.delete(administrative_area_level1)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking administrative_area_level1 changes.

  ## Examples

      iex> change_administrative_area_level1(administrative_area_level1)
      %Ecto.Changeset{source: %AdministrativeAreaLevel1{}}

  """
  def change_administrative_area_level1(%AdministrativeAreaLevel1{} = administrative_area_level1) do
    AdministrativeAreaLevel1.changeset(administrative_area_level1, %{})
  end

  alias Breakbench.AddressComponents.ColloquialArea

  @doc """
  Returns the list of colloquial_areas.

  ## Examples

      iex> list_colloquial_areas()
      [%ColloquialArea{}, ...]

  """
  def list_colloquial_areas do
    Repo.all(ColloquialArea)
  end

  @doc """
  Gets a single colloquial_area.

  ## Examples

      iex> get_colloquial_area(123)
      %ColloquialArea{}

  """
  def get_colloquial_area(id) do
    Repo.get(ColloquialArea, id)
  end

  @doc """
  Creates a colloquial_area.

  ## Examples

      iex> create_colloquial_area(%{field: value})
      {:ok, %ColloquialArea{}}

      iex> create_colloquial_area(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_colloquial_area(attrs \\ %{}) do
    %ColloquialArea{}
    |> ColloquialArea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a colloquial_area.

  ## Examples

      iex> update_colloquial_area(colloquial_area, %{field: new_value})
      {:ok, %ColloquialArea{}}

      iex> update_colloquial_area(colloquial_area, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_colloquial_area(%ColloquialArea{} = colloquial_area, attrs) do
    colloquial_area
    |> ColloquialArea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ColloquialArea.

  ## Examples

      iex> delete_colloquial_area(colloquial_area)
      {:ok, %ColloquialArea{}}

      iex> delete_colloquial_area(colloquial_area)
      {:error, %Ecto.Changeset{}}

  """
  def delete_colloquial_area(%ColloquialArea{} = colloquial_area) do
    Repo.delete(colloquial_area)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking colloquial_area changes.

  ## Examples

      iex> change_colloquial_area(colloquial_area)
      %Ecto.Changeset{source: %ColloquialArea{}}

  """
  def change_colloquial_area(%ColloquialArea{} = colloquial_area) do
    ColloquialArea.changeset(colloquial_area, %{})
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel2

  @doc """
  Returns the list of administrative_area_level_2s.

  ## Examples

      iex> list_administrative_area_level_2s()
      [%AdministrativeAreaLevel2{}, ...]

  """
  def list_administrative_area_level_2s do
    Repo.all(AdministrativeAreaLevel2)
  end

  @doc """
  Gets a single administrative_area_level2.

  ## Examples

      iex> get_administrative_area_level2(123)
      %AdministrativeAreaLevel2{}

  """
  def get_administrative_area_level2(id) do
    Repo.get(AdministrativeAreaLevel2, id)
  end

  @doc """
  Creates a administrative_area_level2.

  ## Examples

      iex> create_administrative_area_level2(%{field: value})
      {:ok, %AdministrativeAreaLevel2{}}

      iex> create_administrative_area_level2(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level2(attrs \\ %{}) do
    %AdministrativeAreaLevel2{}
    |> AdministrativeAreaLevel2.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a administrative_area_level2.

  ## Examples

      iex> update_administrative_area_level2(administrative_area_level2, %{field: new_value})
      {:ok, %AdministrativeAreaLevel2{}}

      iex> update_administrative_area_level2(administrative_area_level2, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_administrative_area_level2(%AdministrativeAreaLevel2{} = administrative_area_level2, attrs) do
    administrative_area_level2
    |> AdministrativeAreaLevel2.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AdministrativeAreaLevel2.

  ## Examples

      iex> delete_administrative_area_level2(administrative_area_level2)
      {:ok, %AdministrativeAreaLevel2{}}

      iex> delete_administrative_area_level2(administrative_area_level2)
      {:error, %Ecto.Changeset{}}

  """
  def delete_administrative_area_level2(%AdministrativeAreaLevel2{} = administrative_area_level2) do
    Repo.delete(administrative_area_level2)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking administrative_area_level2 changes.

  ## Examples

      iex> change_administrative_area_level2(administrative_area_level2)
      %Ecto.Changeset{source: %AdministrativeAreaLevel2{}}

  """
  def change_administrative_area_level2(%AdministrativeAreaLevel2{} = administrative_area_level2) do
    AdministrativeAreaLevel2.changeset(administrative_area_level2, %{})
  end

  alias Breakbench.AddressComponents.PostalCode

  @doc """
  Returns the list of postal_codes.

  ## Examples

      iex> list_postal_codes()
      [%PostalCode{}, ...]

  """
  def list_postal_codes do
    Repo.all(PostalCode)
  end

  @doc """
  Gets a single postal_code.

  ## Examples

      iex> get_postal_code(123)
      %PostalCode{}

  """
  def get_postal_code(id) do
    Repo.get(PostalCode, id)
  end

  @doc """
  Creates a postal_code.

  ## Examples

      iex> create_postal_code(%{field: value})
      {:ok, %PostalCode{}}

      iex> create_postal_code(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_postal_code(attrs \\ %{}) do
    %PostalCode{}
    |> PostalCode.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a postal_code.

  ## Examples

      iex> update_postal_code(postal_code, %{field: new_value})
      {:ok, %PostalCode{}}

      iex> update_postal_code(postal_code, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_postal_code(%PostalCode{} = postal_code, attrs) do
    postal_code
    |> PostalCode.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PostalCode.

  ## Examples

      iex> delete_postal_code(postal_code)
      {:ok, %PostalCode{}}

      iex> delete_postal_code(postal_code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_postal_code(%PostalCode{} = postal_code) do
    Repo.delete(postal_code)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking postal_code changes.

  ## Examples

      iex> change_postal_code(postal_code)
      %Ecto.Changeset{source: %PostalCode{}}

  """
  def change_postal_code(%PostalCode{} = postal_code) do
    PostalCode.changeset(postal_code, %{})
  end

  alias Breakbench.AddressComponents.Locality

  @doc """
  Returns the list of localities.

  ## Examples

      iex> list_localities()
      [%Locality{}, ...]

  """
  def list_localities do
    Repo.all(Locality)
  end

  @doc """
  Gets a single locality.

  ## Examples

      iex> get_locality(123)
      %Locality{}

  """
  def get_locality(id) do
    Repo.get(Locality, id)
  end

  @doc """
  Creates a locality.

  ## Examples

      iex> create_locality(%{field: value})
      {:ok, %Locality{}}

      iex> create_locality(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_locality(attrs \\ %{}) do
    %Locality{}
    |> Locality.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a locality.

  ## Examples

      iex> update_locality(locality, %{field: new_value})
      {:ok, %Locality{}}

      iex> update_locality(locality, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_locality(%Locality{} = locality, attrs) do
    locality
    |> Locality.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Locality.

  ## Examples

      iex> delete_locality(locality)
      {:ok, %Locality{}}

      iex> delete_locality(locality)
      {:error, %Ecto.Changeset{}}

  """
  def delete_locality(%Locality{} = locality) do
    Repo.delete(locality)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking locality changes.

  ## Examples

      iex> change_locality(locality)
      %Ecto.Changeset{source: %Locality{}}

  """
  def change_locality(%Locality{} = locality) do
    Locality.changeset(locality, %{})
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel1ColloquialAreas

  @doc """
  Returns the list of administrative_area_level_1_colloquial_areas.

  ## Examples

      iex> list_administrative_area_level_1_colloquial_areas()
      [%AdministrativeAreaLevel1ColloquialAreas{}, ...]

  """
  def list_administrative_area_level_1_colloquial_areas do
    Repo.all(AdministrativeAreaLevel1ColloquialAreas)
  end

  @doc """
  Check weather a single administrative_area_level1_colloquial_areas exists.

  ## Examples

      iex> has_administrative_area_level1_colloquial_areas(%{field: 123})
      true

  """
  def has_administrative_area_level1_colloquial_areas(attrs) do
    Repo.has?(AdministrativeAreaLevel1ColloquialAreas, attrs)
  end

  @doc """
  Creates a administrative_area_level1_colloquial_areas.

  ## Examples

      iex> create_administrative_area_level1_colloquial_areas(%{field: value})
      {:ok, %AdministrativeAreaLevel1ColloquialAreas{}}

      iex> create_administrative_area_level1_colloquial_areas(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level1_colloquial_areas(attrs \\ %{}) do
    %AdministrativeAreaLevel1ColloquialAreas{}
    |> AdministrativeAreaLevel1ColloquialAreas.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel1AdministrativeAreaLevel2s

  @doc """
  Returns the list of administrative_area_level_1_administrative_area_level_2s.

  ## Examples

      iex> list_administrative_area_level_1_administrative_area_level_2s()
      [%AdministrativeAreaLevel1AdministrativeAreaLevel2s{}, ...]

  """
  def list_administrative_area_level_1_administrative_area_level_2s do
    Repo.all(AdministrativeAreaLevel1AdministrativeAreaLevel2s)
  end

  @doc """
  Check weather a single administrative_area_level1_administrative_area_level2s exists.

  ## Examples

      iex> has_administrative_area_level1_administrative_area_level2s(%{field: 123})
      true

  """
  def has_administrative_area_level1_administrative_area_level2s(attrs) do
    Repo.has?(AdministrativeAreaLevel1AdministrativeAreaLevel2s, attrs)
  end

  @doc """
  Creates a administrative_area_level1_administrative_area_level2s.

  ## Examples

      iex> create_administrative_area_level1_administrative_area_level2s(%{field: value})
      {:ok, %AdministrativeAreaLevel1AdministrativeAreaLevel2s{}}

      iex> create_administrative_area_level1_administrative_area_level2s(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level1_administrative_area_level2s(attrs \\ %{}) do
    %AdministrativeAreaLevel1AdministrativeAreaLevel2s{}
    |> AdministrativeAreaLevel1AdministrativeAreaLevel2s.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel1PostalCodes

  @doc """
  Returns the list of administrative_area_level_1_postal_codes.

  ## Examples

      iex> list_administrative_area_level_1_postal_codes()
      [%AdministrativeAreaLevel1PostalCodes{}, ...]

  """
  def list_administrative_area_level_1_postal_codes do
    Repo.all(AdministrativeAreaLevel1PostalCodes)
  end

  @doc """
  Check weather a single administrative_area_level1_postal_codes exists.

  ## Examples

      iex> has_administrative_area_level1_postal_codes(%{field: 123})
      true

  """
  def has_administrative_area_level1_postal_codes(attrs) do
    Repo.has?(AdministrativeAreaLevel1PostalCodes, attrs)
  end

  @doc """
  Creates a administrative_area_level1_postal_codes.

  ## Examples

      iex> create_administrative_area_level1_postal_codes(%{field: value})
      {:ok, %AdministrativeAreaLevel1PostalCodes{}}

      iex> create_administrative_area_level1_postal_codes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level1_postal_codes(attrs \\ %{}) do
    %AdministrativeAreaLevel1PostalCodes{}
    |> AdministrativeAreaLevel1PostalCodes.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel1Localities

  @doc """
  Returns the list of administrative_area_level_1_localities.

  ## Examples

      iex> list_administrative_area_level_1_localities()
      [%AdministrativeAreaLevel1Localities{}, ...]

  """
  def list_administrative_area_level_1_localities do
    Repo.all(AdministrativeAreaLevel1Localities)
  end

  @doc """
  Check weather a single administrative_area_level1_localities exists.

  ## Examples

      iex> has_administrative_area_level1_localities(%{field: 123})
      true

  """
  def has_administrative_area_level1_localities(attrs) do
    Repo.has?(AdministrativeAreaLevel1Localities, attrs)
  end

  @doc """
  Creates a administrative_area_level1_localities.

  ## Examples

      iex> create_administrative_area_level1_localities(%{field: value})
      {:ok, %AdministrativeAreaLevel1Localities{}}

      iex> create_administrative_area_level1_localities(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level1_localities(attrs \\ %{}) do
    %AdministrativeAreaLevel1Localities{}
    |> AdministrativeAreaLevel1Localities.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.ColloquialAreaAdministrativeAreaLevel2s

  @doc """
  Returns the list of colloquial_area_administrative_area_level_2s.

  ## Examples

      iex> list_colloquial_area_administrative_area_level_2s()
      [%ColloquialAreaAdministrativeAreaLevel2s{}, ...]

  """
  def list_colloquial_area_administrative_area_level_2s do
    Repo.all(ColloquialAreaAdministrativeAreaLevel2s)
  end

  @doc """
  Check weather a single colloquial_area_administrative_area_level2s exists.

  ## Examples

      iex> has_colloquial_area_administrative_area_level2s(%{field: 123})
      true

  """
  def has_colloquial_area_administrative_area_level2s(attrs) do
    Repo.has?(ColloquialAreaAdministrativeAreaLevel2s, attrs)
  end

  @doc """
  Creates a colloquial_area_administrative_area_level2s.

  ## Examples

      iex> create_colloquial_area_administrative_area_level2s(%{field: value})
      {:ok, %ColloquialAreaAdministrativeAreaLevel2s{}}

      iex> create_colloquial_area_administrative_area_level2s(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_colloquial_area_administrative_area_level2s(attrs \\ %{}) do
    %ColloquialAreaAdministrativeAreaLevel2s{}
    |> ColloquialAreaAdministrativeAreaLevel2s.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.ColloquialAreaPostalCodes

  @doc """
  Returns the list of colloquial_area_postal_codes.

  ## Examples

      iex> list_colloquial_area_postal_codes()
      [%ColloquialAreaPostalCodes{}, ...]

  """
  def list_colloquial_area_postal_codes do
    Repo.all(ColloquialAreaPostalCodes)
  end

  @doc """
  Check weather a single colloquial_postal_codes exists.

  ## Examples

      iex> has_colloquial_area_postal_codes(%{field: 123})
      true

  """
  def has_colloquial_area_postal_codes(attrs) do
    Repo.has?(ColloquialAreaPostalCodes, attrs)
  end

  @doc """
  Creates a colloquial_postal_codes.

  ## Examples

      iex> create_colloquial_area_postal_codes(%{field: value})
      {:ok, %ColloquialAreaPostalCodes{}}

      iex> create_colloquial_area_postal_codes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_colloquial_area_postal_codes(attrs \\ %{}) do
    %ColloquialAreaPostalCodes{}
    |> ColloquialAreaPostalCodes.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.ColloquialAreaLocalities

  @doc """
  Returns the list of colloquial_area_localities.

  ## Examples

      iex> list_colloquial_area_localities()
      [%ColloquialAreaLocalities{}, ...]

  """
  def list_colloquial_area_localities do
    Repo.all(ColloquialAreaLocalities)
  end

  @doc """
  Check weather a single colloquial_localities exists.

  ## Examples

      iex> has_colloquial_area_localities(%{field: 123})
      true

  """
  def has_colloquial_area_localities(attrs) do
    Repo.has?(ColloquialAreaLocalities, attrs)
  end

  @doc """
  Creates a colloquial_localities.

  ## Examples

      iex> create_colloquial_area_localities(%{field: value})
      {:ok, %ColloquialAreaLocalities{}}

      iex> create_colloquial_area_localities(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_colloquial_area_localities(attrs \\ %{}) do
    %ColloquialAreaLocalities{}
    |> ColloquialAreaLocalities.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel2PostalCodes

  @doc """
  Returns the list of administrative_area_level_2_postal_codes.

  ## Examples

      iex> list_administrative_area_level_2_postal_codes()
      [%AdministrativeAreaLevel2PostalCodes{}, ...]

  """
  def list_administrative_area_level_2_postal_codes do
    Repo.all(AdministrativeAreaLevel2PostalCodes)
  end

  @doc """
  Check weather a single administrative_area_level2_postal_codes exists.

  ## Examples

      iex> has_administrative_area_level2_postal_codes(%{field: 123})
      true

  """
  def has_administrative_area_level2_postal_codes(attrs) do
    Repo.has?(AdministrativeAreaLevel2PostalCodes, attrs)
  end

  @doc """
  Creates a administrative_area_level2_postal_codes.

  ## Examples

      iex> create_administrative_area_level2_postal_codes(%{field: value})
      {:ok, %AdministrativeAreaLevel2PostalCodes{}}

      iex> create_administrative_area_level2_postal_codes(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level2_postal_codes(attrs \\ %{}) do
    %AdministrativeAreaLevel2PostalCodes{}
    |> AdministrativeAreaLevel2PostalCodes.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.AdministrativeAreaLevel2Localities

  @doc """
  Returns the list of administrative_area_level_2_localities.

  ## Examples

      iex> list_administrative_area_level_2_localities()
      [%AdministrativeAreaLevel2Localities{}, ...]

  """
  def list_administrative_area_level_2_localities do
    Repo.all(AdministrativeAreaLevel2Localities)
  end

  @doc """
  Check weather a single administrative_area_level2_localities exists.

  ## Examples

      iex> has_administrative_area_level2_localities(%{field: 123})
      true

  """
  def has_administrative_area_level2_localities(attrs) do
    Repo.has?(AdministrativeAreaLevel2Localities, attrs)
  end

  @doc """
  Creates a administrative_area_level2_localities.

  ## Examples

      iex> create_administrative_area_level2_localities(%{field: value})
      {:ok, %AdministrativeAreaLevel2Localities{}}

      iex> create_administrative_area_level2_localities(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_administrative_area_level2_localities(attrs \\ %{}) do
    %AdministrativeAreaLevel2Localities{}
    |> AdministrativeAreaLevel2Localities.changeset(attrs)
    |> Repo.insert()
  end

  alias Breakbench.AddressComponents.PostalCodeLocalities

  @doc """
  Returns the list of postal_code_localities.

  ## Examples

      iex> list_postal_code_localities()
      [%PostalCodeLocalities{}, ...]

  """
  def list_postal_code_localities do
    Repo.all(PostalCodeLocalities)
  end

  @doc """
  Check weather a single postal_code_localities exists.

  ## Examples

      iex> has_postal_code_localities(%{field: 123})
      true

  """
  def has_postal_code_localities(attrs) do
    Repo.has?(PostalCodeLocalities, attrs)
  end

  @doc """
  Creates a postal_code_localities.

  ## Examples

      iex> create_postal_code_localities(%{field: value})
      {:ok, %PostalCodeLocalities{}}

      iex> create_postal_code_localities(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_postal_code_localities(attrs \\ %{}) do
    %PostalCodeLocalities{}
    |> PostalCodeLocalities.changeset(attrs)
    |> Repo.insert()
  end
end
