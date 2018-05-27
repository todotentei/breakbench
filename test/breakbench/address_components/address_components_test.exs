defmodule Breakbench.AddressComponentsTest do
  use Breakbench.DataCase

  alias Breakbench.AddressComponents

  describe "countries" do
    alias Breakbench.AddressComponents.Country

    @valid_attrs %{long_name: "long_name", short_name: "short_name"}
    @update_attrs %{long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{long_name: nil, short_name: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_country()

      country
    end

    test "list_countries/0 returns all countries" do
      country = country_fixture()
      assert AddressComponents.list_countries() == [country]
    end

    test "get_country/1 returns the country with given id" do
      country = country_fixture()
      assert AddressComponents.get_country(country.short_name) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = AddressComponents.create_country(@valid_attrs)
      assert country.long_name == "long_name"
      assert country.short_name == "short_name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, country} = AddressComponents.update_country(country, @update_attrs)
      assert %Country{} = country
      assert country.long_name == "updated long_name"
      assert country.short_name == "updated short_name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_country(country, @invalid_attrs)
      assert country == AddressComponents.get_country(country.short_name)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = AddressComponents.delete_country(country)
      refute AddressComponents.get_country(country.short_name)
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_country(country)
    end
  end

  describe "administrative_area_level_1s" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel1

    @valid_attrs %{country_short_name: "short_name", long_name: "long_name", short_name: "short_name"}
    @update_attrs %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{country_short_name: "short_name", long_name: nil, short_name: nil}

    setup do
      country_attrs = %{short_name: "short_name", long_name: "long_name"}
      {:ok, country} = AddressComponents.create_country(country_attrs)
      {:ok, country: country}
    end

    def administrative_area_level1_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level1} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level1()

      administrative_area_level1
    end

    test "list_administrative_area_level_1s/0 returns all administrative_area_level_1s", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert AddressComponents.list_administrative_area_level_1s() == [administrative_area_level1]
    end

    test "get_administrative_area_level1/1 returns the administrative_area_level1 with given id", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert AddressComponents.get_administrative_area_level1(administrative_area_level1.id) == administrative_area_level1
    end

    test "create_administrative_area_level1/1 with valid data creates a administrative_area_level1", _ do
      assert {:ok, %AdministrativeAreaLevel1{} = administrative_area_level1} = AddressComponents.create_administrative_area_level1(@valid_attrs)
      assert administrative_area_level1.long_name == "long_name"
      assert administrative_area_level1.short_name == "short_name"
    end

    test "create_administrative_area_level1/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level1(@invalid_attrs)
    end

    test "update_administrative_area_level1/2 with valid data updates the administrative_area_level1", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert {:ok, administrative_area_level1} = AddressComponents.update_administrative_area_level1(administrative_area_level1, @update_attrs)
      assert %AdministrativeAreaLevel1{} = administrative_area_level1
      assert administrative_area_level1.long_name == "updated long_name"
      assert administrative_area_level1.short_name == "updated short_name"
    end

    test "update_administrative_area_level1/2 with invalid data returns error changeset", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_administrative_area_level1(administrative_area_level1, @invalid_attrs)
      assert administrative_area_level1 == AddressComponents.get_administrative_area_level1(administrative_area_level1.id)
    end

    test "delete_administrative_area_level1/1 deletes the administrative_area_level1", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert {:ok, %AdministrativeAreaLevel1{}} = AddressComponents.delete_administrative_area_level1(administrative_area_level1)
      refute AddressComponents.get_administrative_area_level1(administrative_area_level1.id)
    end

    test "change_administrative_area_level1/1 returns a administrative_area_level1 changeset", _ do
      administrative_area_level1 = administrative_area_level1_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_administrative_area_level1(administrative_area_level1)
    end
  end

  describe "colloquial_areas" do
    alias Breakbench.AddressComponents.ColloquialArea

    @valid_attrs %{country_short_name: "short_name", long_name: "long_name", short_name: "short_name"}
    @update_attrs %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{country_short_name: "short_name", long_name: nil, short_name: nil}

    setup do
      country_attrs = %{short_name: "short_name", long_name: "long_name"}
      {:ok, country} = AddressComponents.create_country(country_attrs)
      {:ok, country: country}
    end

    def colloquial_area_fixture(attrs \\ %{}) do
      {:ok, colloquial_area} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_colloquial_area()

      colloquial_area
    end

    test "list_colloquial_areas/0 returns all colloquial_areas", _ do
      colloquial_area = colloquial_area_fixture()
      assert AddressComponents.list_colloquial_areas() == [colloquial_area]
    end

    test "get_colloquial_area/1 returns the colloquial_area with given id", _ do
      colloquial_area = colloquial_area_fixture()
      assert AddressComponents.get_colloquial_area(colloquial_area.id) == colloquial_area
    end

    test "create_colloquial_area/1 with valid data creates a colloquial_area", _ do
      assert {:ok, %ColloquialArea{} = colloquial_area} = AddressComponents.create_colloquial_area(@valid_attrs)
      assert colloquial_area.long_name == "long_name"
      assert colloquial_area.short_name == "short_name"
    end

    test "create_colloquial_area/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_colloquial_area(@invalid_attrs)
    end

    test "update_colloquial_area/2 with valid data updates the colloquial_area", _ do
      colloquial_area = colloquial_area_fixture()
      assert {:ok, colloquial_area} = AddressComponents.update_colloquial_area(colloquial_area, @update_attrs)
      assert %ColloquialArea{} = colloquial_area
      assert colloquial_area.long_name == "updated long_name"
      assert colloquial_area.short_name == "updated short_name"
    end

    test "update_colloquial_area/2 with invalid data returns error changeset", _ do
      colloquial_area = colloquial_area_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_colloquial_area(colloquial_area, @invalid_attrs)
      assert colloquial_area == AddressComponents.get_colloquial_area(colloquial_area.id)
    end

    test "delete_colloquial_area/1 deletes the colloquial_area", _ do
      colloquial_area = colloquial_area_fixture()
      assert {:ok, %ColloquialArea{}} = AddressComponents.delete_colloquial_area(colloquial_area)
      refute AddressComponents.get_colloquial_area(colloquial_area.id)
    end

    test "change_colloquial_area/1 returns a colloquial_area changeset", _ do
      colloquial_area = colloquial_area_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_colloquial_area(colloquial_area)
    end
  end

  describe "administrative_area_level_2s" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel2

    @valid_attrs %{country_short_name: "short_name", long_name: "long_name", short_name: "short_name"}
    @update_attrs %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{country_short_name: "short_name", long_name: nil, short_name: nil}

    setup do
      country_attrs = %{short_name: "short_name", long_name: "long_name"}
      {:ok, country} = AddressComponents.create_country(country_attrs)
      {:ok, country: country}
    end

    def administrative_area_level2_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level2} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level2()

      administrative_area_level2
    end

    test "list_administrative_area_level_2s/0 returns all administrative_area_level_2s", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert AddressComponents.list_administrative_area_level_2s() == [administrative_area_level2]
    end

    test "get_administrative_area_level2/1 returns the administrative_area_level2 with given id", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert AddressComponents.get_administrative_area_level2(administrative_area_level2.id) == administrative_area_level2
    end

    test "create_administrative_area_level2/1 with valid data creates a administrative_area_level2", _ do
      assert {:ok, %AdministrativeAreaLevel2{} = administrative_area_level2} = AddressComponents.create_administrative_area_level2(@valid_attrs)
      assert administrative_area_level2.long_name == "long_name"
      assert administrative_area_level2.short_name == "short_name"
    end

    test "create_administrative_area_level2/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level2(@invalid_attrs)
    end

    test "update_administrative_area_level2/2 with valid data updates the administrative_area_level2", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert {:ok, administrative_area_level2} = AddressComponents.update_administrative_area_level2(administrative_area_level2, @update_attrs)
      assert %AdministrativeAreaLevel2{} = administrative_area_level2
      assert administrative_area_level2.long_name == "updated long_name"
      assert administrative_area_level2.short_name == "updated short_name"
    end

    test "update_administrative_area_level2/2 with invalid data returns error changeset", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_administrative_area_level2(administrative_area_level2, @invalid_attrs)
      assert administrative_area_level2 == AddressComponents.get_administrative_area_level2(administrative_area_level2.id)
    end

    test "delete_administrative_area_level2/1 deletes the administrative_area_level2", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert {:ok, %AdministrativeAreaLevel2{}} = AddressComponents.delete_administrative_area_level2(administrative_area_level2)
      refute AddressComponents.get_administrative_area_level2(administrative_area_level2.id)
    end

    test "change_administrative_area_level2/1 returns a administrative_area_level2 changeset", _ do
      administrative_area_level2 = administrative_area_level2_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_administrative_area_level2(administrative_area_level2)
    end
  end

  describe "postal_codes" do
    alias Breakbench.AddressComponents.PostalCode

    @valid_attrs %{country_short_name: "short_name", long_name: "long_name", short_name: "short_name"}
    @update_attrs %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{country_short_name: "short_name", long_name: nil, short_name: nil}

    setup do
      country_attrs = %{short_name: "short_name", long_name: "long_name"}
      {:ok, country} = AddressComponents.create_country(country_attrs)
      {:ok, country: country}
    end

    def postal_code_fixture(attrs \\ %{}) do
      {:ok, postal_code} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_postal_code()

      postal_code
    end

    test "list_postal_codes/0 returns all postal_codes", _ do
      postal_code = postal_code_fixture()
      assert AddressComponents.list_postal_codes() == [postal_code]
    end

    test "get_postal_code/1 returns the postal_code with given id", _ do
      postal_code = postal_code_fixture()
      assert AddressComponents.get_postal_code(postal_code.id) == postal_code
    end

    test "create_postal_code/1 with valid data creates a postal_code", _ do
      assert {:ok, %PostalCode{} = postal_code} = AddressComponents.create_postal_code(@valid_attrs)
      assert postal_code.long_name == "long_name"
      assert postal_code.short_name == "short_name"
    end

    test "create_postal_code/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_postal_code(@invalid_attrs)
    end

    test "update_postal_code/2 with valid data updates the postal_code", _ do
      postal_code = postal_code_fixture()
      assert {:ok, postal_code} = AddressComponents.update_postal_code(postal_code, @update_attrs)
      assert %PostalCode{} = postal_code
      assert postal_code.long_name == "updated long_name"
      assert postal_code.short_name == "updated short_name"
    end

    test "update_postal_code/2 with invalid data returns error changeset", _ do
      postal_code = postal_code_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_postal_code(postal_code, @invalid_attrs)
      assert postal_code == AddressComponents.get_postal_code(postal_code.id)
    end

    test "delete_postal_code/1 deletes the postal_code", _ do
      postal_code = postal_code_fixture()
      assert {:ok, %PostalCode{}} = AddressComponents.delete_postal_code(postal_code)
      refute AddressComponents.get_postal_code(postal_code.id)
    end

    test "change_postal_code/1 returns a postal_code changeset", _ do
      postal_code = postal_code_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_postal_code(postal_code)
    end
  end

  describe "localities" do
    alias Breakbench.AddressComponents.Locality

    @valid_attrs %{country_short_name: "short_name", long_name: "long_name", short_name: "short_name"}
    @update_attrs %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}
    @invalid_attrs %{country_short_name: "short_name", long_name: nil, short_name: nil}

    setup do
      country_attrs = %{short_name: "short_name", long_name: "long_name"}
      {:ok, country} = AddressComponents.create_country(country_attrs)
      {:ok, country: country}
    end

    def locality_fixture(attrs \\ %{}) do
      {:ok, locality} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_locality()

      locality
    end

    test "list_localities/0 returns all localities", _ do
      locality = locality_fixture()
      assert AddressComponents.list_localities() == [locality]
    end

    test "get_locality/1 returns the locality with given id", _ do
      locality = locality_fixture()
      assert AddressComponents.get_locality(locality.id) == locality
    end

    test "create_locality/1 with valid data creates a locality", _ do
      assert {:ok, %Locality{} = locality} = AddressComponents.create_locality(@valid_attrs)
      assert locality.long_name == "long_name"
      assert locality.short_name == "short_name"
    end

    test "create_locality/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_locality(@invalid_attrs)
    end

    test "update_locality/2 with valid data updates the locality", _ do
      locality = locality_fixture()
      assert {:ok, locality} = AddressComponents.update_locality(locality, @update_attrs)
      assert %Locality{} = locality
      assert locality.long_name == "updated long_name"
      assert locality.short_name == "updated short_name"
    end

    test "update_locality/2 with invalid data returns error changeset", _ do
      locality = locality_fixture()
      assert {:error, %Ecto.Changeset{}} = AddressComponents.update_locality(locality, @invalid_attrs)
      assert locality == AddressComponents.get_locality(locality.id)
    end

    test "delete_locality/1 deletes the locality", _ do
      locality = locality_fixture()
      assert {:ok, %Locality{}} = AddressComponents.delete_locality(locality)
      refute AddressComponents.get_locality(locality.id)
    end

    test "change_locality/1 returns a locality changeset", _ do
      locality = locality_fixture()
      assert %Ecto.Changeset{} = AddressComponents.change_locality(locality)
    end
  end

  describe "administrative_area_level_1_colloquial_areas" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel1ColloquialAreas

    @valid_attrs %{administrative_area_level_1_id: 123, colloquial_area_id: 234}
    @invalid_attrs %{administrative_area_level_1_id: 456, colloquial_area_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel1{id: 123}
        |> AddressComponents.AdministrativeAreaLevel1.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.ColloquialArea{id: 234}
        |> AddressComponents.ColloquialArea.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_1: t2, colloquial_area: t3]}
    end

    def administrative_area_level1_colloquial_areas_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level1_colloquial_areas} = attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level1_colloquial_areas()

      administrative_area_level1_colloquial_areas
    end

    test "list_administrative_area_level_1_colloquial_areas/0 returns all administrative_area_level_1_colloquial_areas", _ do
      fixture = administrative_area_level1_colloquial_areas_fixture()
      assert AddressComponents.list_administrative_area_level_1_colloquial_areas() == [fixture]
    end

    test "has_administrative_area_level1_colloquial_areas/1 returns boolean with given attrs", _ do
      administrative_area_level1_colloquial_areas_fixture()
      assert AddressComponents.has_administrative_area_level1_colloquial_areas(@valid_attrs)
      refute AddressComponents.has_administrative_area_level1_colloquial_areas(@invalid_attrs)
    end

    test "create_administrative_area_level1_colloquial_areas/1 with valid data creates a administrative_area_level1_colloquial_areas", _ do
      assert {:ok, %AdministrativeAreaLevel1ColloquialAreas{}} = AddressComponents.create_administrative_area_level1_colloquial_areas(@valid_attrs)
    end

    test "create_administrative_area_level1_colloquial_areas/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level1_colloquial_areas(@invalid_attrs)
    end
  end

  describe "administrative_area_level_1_administrative_area_level_2s" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel1AdministrativeAreaLevel2s

    @valid_attrs %{administrative_area_level_1_id: 123, administrative_area_level_2_id: 234}
    @invalid_attrs %{administrative_area_level_1_id: 456, administrative_area_level_2_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel1{id: 123}
        |> AddressComponents.AdministrativeAreaLevel1.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.AdministrativeAreaLevel2{id: 234}
        |> AddressComponents.AdministrativeAreaLevel2.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_1: t2, administrative_area_level_2: t3]}
    end

    def administrative_area_level1_administrative_area_level2s_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level1_administrative_area_level2s} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level1_administrative_area_level2s()

      administrative_area_level1_administrative_area_level2s
    end

    test "list_administrative_area_level_1_administrative_area_level_2s/0 returns all administrative_area_level_1_administrative_area_level_2s", _ do
      fixture = administrative_area_level1_administrative_area_level2s_fixture()
      assert AddressComponents.list_administrative_area_level_1_administrative_area_level_2s() == [fixture]
    end

    test "has_administrative_area_level1_administrative_area_level2s/1 returns boolean with given attrs", _ do
      administrative_area_level1_administrative_area_level2s_fixture()
      assert AddressComponents.has_administrative_area_level1_administrative_area_level2s(@valid_attrs)
      refute AddressComponents.has_administrative_area_level1_administrative_area_level2s(@invalid_attrs)
    end

    test "create_administrative_area_level1_administrative_area_level2s/1 with valid data creates a administrative_area_level1_administrative_area_level2s", _ do
      assert {:ok, %AdministrativeAreaLevel1AdministrativeAreaLevel2s{}} = AddressComponents.create_administrative_area_level1_administrative_area_level2s(@valid_attrs)
    end

    test "create_administrative_area_level1_administrative_area_level2s/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level1_administrative_area_level2s(@invalid_attrs)
    end
  end

  describe "administrative_area_level_1_postal_codes" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel1PostalCodes

    @valid_attrs %{administrative_area_level_1_id: 123, postal_code_id: 234}
    @invalid_attrs %{administrative_area_level_1_id: 456, postal_code_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel1{id: 123}
        |> AddressComponents.AdministrativeAreaLevel1.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.PostalCode{id: 234}
        |> AddressComponents.PostalCode.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_1: t2, postal_code: t3]}
    end

    def administrative_area_level1_postal_codes_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level1_postal_codes} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level1_postal_codes()

      administrative_area_level1_postal_codes
    end

    test "list_administrative_area_level_1_postal_codes/0 returns all administrative_area_level_1_postal_codes", _ do
      fixture = administrative_area_level1_postal_codes_fixture()
      assert AddressComponents.list_administrative_area_level_1_postal_codes() == [fixture]
    end

    test "has_administrative_area_level1_postal_codes/1 returns boolean with given attrs", _ do
      administrative_area_level1_postal_codes_fixture()
      assert AddressComponents.has_administrative_area_level1_postal_codes(@valid_attrs)
      refute AddressComponents.has_administrative_area_level1_postal_codes(@invalid_attrs)
    end

    test "create_administrative_area_level1_postal_codes/1 with valid data creates a administrative_area_level1_postal_codes", _ do
      assert {:ok, %AdministrativeAreaLevel1PostalCodes{}} = AddressComponents.create_administrative_area_level1_postal_codes(@valid_attrs)
    end

    test "create_administrative_area_level1_postal_codes/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level1_postal_codes(@invalid_attrs)
    end
  end

  describe "administrative_area_level_1_localities" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel1Localities

    @valid_attrs %{administrative_area_level_1_id: 123, locality_id: 234}
    @invalid_attrs %{administrative_area_level_1_id: 456, locality_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel1{id: 123}
        |> AddressComponents.AdministrativeAreaLevel1.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.Locality{id: 234}
        |> AddressComponents.Locality.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_1: t2, locality: t3]}
    end

    def administrative_area_level1_localities_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level1_localities} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level1_localities()

      administrative_area_level1_localities
    end

    test "list_administrative_area_level_1_localities/0 returns all administrative_area_level_1_localities", _ do
      fixture = administrative_area_level1_localities_fixture()
      assert AddressComponents.list_administrative_area_level_1_localities() == [fixture]
    end

    test "has_administrative_area_level1_localities/1 returns boolean with given attrs", _ do
      administrative_area_level1_localities_fixture()
      assert AddressComponents.has_administrative_area_level1_localities(@valid_attrs)
      refute AddressComponents.has_administrative_area_level1_localities(@invalid_attrs)
    end

    test "create_administrative_area_level1_localities/1 with valid data creates a administrative_area_level1_localities", _ do
      assert {:ok, %AdministrativeAreaLevel1Localities{}} = AddressComponents.create_administrative_area_level1_localities(@valid_attrs)
    end

    test "create_administrative_area_level1_localities/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level1_localities(@invalid_attrs)
    end
  end

  describe "colloquial_area_administrative_area_level_2s" do
    alias Breakbench.AddressComponents.ColloquialAreaAdministrativeAreaLevel2s

    @valid_attrs %{colloquial_area_id: 123, administrative_area_level_2_id: 234}
    @invalid_attrs %{colloquial_area_id: 456, administrative_area_level_2_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.ColloquialArea{id: 123}
        |> AddressComponents.ColloquialArea.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.AdministrativeAreaLevel2{id: 234}
        |> AddressComponents.AdministrativeAreaLevel2.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, colloquial_area: t2, administrative_area_level_2: t3]}
    end

    def colloquial_area_administrative_area_level2s_fixture(attrs \\ %{}) do
      {:ok, colloquial_area_administrative_area_level2s} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_colloquial_area_administrative_area_level2s()

      colloquial_area_administrative_area_level2s
    end

    test "list_colloquial_area_administrative_area_level_2s/0 returns all colloquial_area_administrative_area_level_2s", _ do
      fixture = colloquial_area_administrative_area_level2s_fixture()
      assert AddressComponents.list_colloquial_area_administrative_area_level_2s() == [fixture]
    end

    test "has_colloquial_area_administrative_area_level2s/1 returns boolean with given attrs", _ do
      colloquial_area_administrative_area_level2s_fixture()
      assert AddressComponents.has_colloquial_area_administrative_area_level2s(@valid_attrs)
      refute AddressComponents.has_colloquial_area_administrative_area_level2s(@invalid_attrs)
    end

    test "create_colloquial_area_administrative_area_level2s/1 with valid data creates a colloquial_area_administrative_area_level2s", _ do
      assert {:ok, %ColloquialAreaAdministrativeAreaLevel2s{}} = AddressComponents.create_colloquial_area_administrative_area_level2s(@valid_attrs)
    end

    test "create_colloquial_area_administrative_area_level2s/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_colloquial_area_administrative_area_level2s(@invalid_attrs)
    end
  end

  describe "colloquial_area_postal_codes" do
    alias Breakbench.AddressComponents.ColloquialAreaPostalCodes

    @valid_attrs %{colloquial_area_id: 123, postal_code_id: 234}
    @invalid_attrs %{colloquial_area_id: 456, postal_code_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.ColloquialArea{id: 123}
        |> AddressComponents.ColloquialArea.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.PostalCode{id: 234}
        |> AddressComponents.PostalCode.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, colloquial_area: t2, postal_code: t3]}
    end

    def colloquial_area_postal_codes_fixture(attrs \\ %{}) do
      {:ok, colloquial_postal_codes} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_colloquial_area_postal_codes()

      colloquial_postal_codes
    end

    test "list_colloquial_area_postal_codes/0 returns all colloquial_area_postal_codes", _ do
      fixture = colloquial_area_postal_codes_fixture()
      assert AddressComponents.list_colloquial_area_postal_codes() == [fixture]
    end

    test "has_colloquial_area_postal_codes/1 returns boolean with given attrs", _ do
      colloquial_area_postal_codes_fixture()
      assert AddressComponents.has_colloquial_area_postal_codes(@valid_attrs)
      refute AddressComponents.has_colloquial_area_postal_codes(@invalid_attrs)
    end

    test "create_colloquial_area_postal_codes/1 with valid data creates a colloquial_postal_codes", _ do
      assert {:ok, %ColloquialAreaPostalCodes{}} = AddressComponents.create_colloquial_area_postal_codes(@valid_attrs)
    end

    test "create_colloquial_area_postal_codes/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_colloquial_area_postal_codes(@invalid_attrs)
    end
  end

  describe "colloquial_area_localities" do
    alias Breakbench.AddressComponents.ColloquialAreaLocalities

    @valid_attrs %{colloquial_area_id: 123, locality_id: 234}
    @invalid_attrs %{colloquial_area_id: 456, locality_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.ColloquialArea{id: 123}
        |> AddressComponents.ColloquialArea.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.Locality{id: 234}
        |> AddressComponents.Locality.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, colloquial_area: t2, locality: t3]}
    end

    def colloquial_area_localities_fixture(attrs \\ %{}) do
      {:ok, colloquial_localities} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_colloquial_area_localities()

      colloquial_localities
    end

    test "list_colloquial_area_localities/0 returns all colloquial_area_localities", _ do
      fixture = colloquial_area_localities_fixture()
      assert AddressComponents.list_colloquial_area_localities() == [fixture]
    end

    test "has_colloquial_area_localities/1 returns boolean with given attrs", _ do
      colloquial_area_localities_fixture()
      assert AddressComponents.has_colloquial_area_localities(@valid_attrs)
      refute AddressComponents.has_colloquial_area_localities(@invalid_attrs)
    end

    test "create_colloquial_area_localities/1 with valid data creates a colloquial_localities", _ do
      assert {:ok, %ColloquialAreaLocalities{}} = AddressComponents.create_colloquial_area_localities(@valid_attrs)
    end

    test "create_colloquial_area_localities/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_colloquial_area_localities(@invalid_attrs)
    end
  end

  describe "administrative_area_level_2_postal_codes" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel2PostalCodes

    @valid_attrs %{administrative_area_level_2_id: 123, postal_code_id: 234}
    @invalid_attrs %{administrative_area_level_2_id: 456, postal_code_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel2{id: 123}
        |> AddressComponents.AdministrativeAreaLevel2.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.PostalCode{id: 234}
        |> AddressComponents.PostalCode.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_2: t2, postal_code: t3]}
    end

    def administrative_area_level2_postal_codes_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level2_postal_codes} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level2_postal_codes()

      administrative_area_level2_postal_codes
    end

    test "list_administrative_area_level_2_postal_codes/0 returns all administrative_area_level_2_postal_codes", _ do
      fixture = administrative_area_level2_postal_codes_fixture()
      assert AddressComponents.list_administrative_area_level_2_postal_codes() == [fixture]
    end

    test "has_administrative_area_level2_postal_codes/1 returns boolean with given attrs", _ do
      administrative_area_level2_postal_codes_fixture()
      assert AddressComponents.has_administrative_area_level2_postal_codes(@valid_attrs)
      refute AddressComponents.has_administrative_area_level2_postal_codes(@invalid_attrs)
    end

    test "create_administrative_area_level2_postal_codes/1 with valid data creates a administrative_area_level2_postal_codes", _ do
      assert {:ok, %AdministrativeAreaLevel2PostalCodes{}} = AddressComponents.create_administrative_area_level2_postal_codes(@valid_attrs)
    end

    test "create_administrative_area_level2_postal_codes/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level2_postal_codes(@invalid_attrs)
    end
  end

  describe "administrative_area_level_2_localities" do
    alias Breakbench.AddressComponents.AdministrativeAreaLevel2Localities

    @valid_attrs %{administrative_area_level_2_id: 123, locality_id: 234}
    @invalid_attrs %{administrative_area_level_2_id: 456, locality_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.AdministrativeAreaLevel2{id: 123}
        |> AddressComponents.AdministrativeAreaLevel2.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.Locality{id: 234}
        |> AddressComponents.Locality.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, administrative_area_level_2: t2, locality: t3]}
    end

    def administrative_area_level2_localities_fixture(attrs \\ %{}) do
      {:ok, administrative_area_level2_localities} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_administrative_area_level2_localities()

      administrative_area_level2_localities
    end

    test "list_administrative_area_level_2_localities/0 returns all administrative_area_level_2_localities", _ do
      fixture = administrative_area_level2_localities_fixture()
      assert AddressComponents.list_administrative_area_level_2_localities() == [fixture]
    end

    test "has_administrative_area_level2_localities/1 returns the boolean with given attrs", _ do
      administrative_area_level2_localities_fixture()
      assert AddressComponents.has_administrative_area_level2_localities(@valid_attrs)
      refute AddressComponents.has_administrative_area_level2_localities(@invalid_attrs)
    end

    test "create_administrative_area_level2_localities/1 with valid data creates a administrative_area_level2_localities", _ do
      assert {:ok, %AdministrativeAreaLevel2Localities{}} = AddressComponents.create_administrative_area_level2_localities(@valid_attrs)
    end

    test "create_administrative_area_level2_localities/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_administrative_area_level2_localities(@invalid_attrs)
    end
  end

  describe "postal_code_localities" do
    alias Breakbench.AddressComponents.PostalCodeLocalities

    @valid_attrs %{postal_code_id: 123, locality_id: 234}
    @invalid_attrs %{postal_code_id: 456, locality_id: 567}

    setup do
      attrs = %{country_short_name: "short_name", long_name: "updated long_name", short_name: "updated short_name"}

      {:ok, t1} = %{short_name: "short_name", long_name: "long_name"}
        |> AddressComponents.create_country()
      {:ok, t2} = %AddressComponents.PostalCode{id: 123}
        |> AddressComponents.PostalCode.changeset(attrs)
        |> Repo.insert()
      {:ok, t3} = %AddressComponents.Locality{id: 234}
        |> AddressComponents.Locality.changeset(attrs)
        |> Repo.insert()

      {:ok, [country: t1, postal_code: t2, locality: t3]}
    end

    def postal_code_localities_fixture(attrs \\ %{}) do
      {:ok, postal_code_localities} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AddressComponents.create_postal_code_localities()

      postal_code_localities
    end

    test "list_postal_code_localities/0 returns all postal_code_localities", _ do
      fixture = postal_code_localities_fixture()
      assert AddressComponents.list_postal_code_localities() == [fixture]
    end

    test "has_postal_code_localities/1 returns the boolean with given attrs", _ do
      postal_code_localities_fixture()
      assert AddressComponents.has_postal_code_localities(@valid_attrs)
      refute AddressComponents.has_postal_code_localities(@invalid_attrs)
    end

    test "create_postal_code_localities/1 with valid data creates a postal_code_localities", _ do
      assert {:ok, %PostalCodeLocalities{}} = AddressComponents.create_postal_code_localities(@valid_attrs)
    end

    test "create_postal_code_localities/1 with invalid data returns error changeset", _ do
      assert {:error, %Ecto.Changeset{}} = AddressComponents.create_postal_code_localities(@invalid_attrs)
    end
  end
end
