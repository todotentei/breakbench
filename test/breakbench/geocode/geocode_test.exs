defmodule Breakbench.GeocodeTest do
  use Breakbench.DataCase

  describe "google geocode" do
    alias Breakbench.{AddressComponents, Geocode}

    @country_attrs %{long_name: "Australia", short_name: "AU"}
    @administrative_area_level_1_attrs %{long_name: "Victoria", short_name: "VIC"}
    @colloquial_area_attrs %{long_name: "Melbourne", short_name: "Melbourne"}
    @administrative_area_level_2_attrs %{long_name: "Whitehorse City", short_name: "Whitehorse"}
    @postal_code_attrs %{long_name: "3125", short_name: "3125"}
    @locality_attrs %{long_name: "Burwood", short_name: "Burwood"}

    @google_geocode struct(Geocode.Google, [
      {:country, struct(Geocode.CountryComponent, @country_attrs)},
      {:administrative_area_level_1, struct(Geocode.AdministrativeAreaLevel1Component, @administrative_area_level_1_attrs)},
      {:colloquial_area, struct(Geocode.ColloquialAreaComponent, @colloquial_area_attrs)},
      {:administrative_area_level_2, struct(Geocode.AdministrativeAreaLevel2Component, @administrative_area_level_2_attrs)},
      {:postal_code, struct(Geocode.PostalCodeComponent, @postal_code_attrs)},
      {:locality, struct(Geocode.LocalityComponent, @locality_attrs)}
    ])

    setup do
      {:ok, pid} = Breakbench.Geocode.Google.start_link
      {:ok, pid: pid}
    end

    test "resolve/1 database record with a given geocode", %{pid: pid} do
      GenServer.cast(pid, {:resolve, @google_geocode})
      :sys.get_state(pid)

      assert __ = Repo.get_by(AddressComponents.Country, @country_attrs)
      assert a1 = Repo.get_by(AddressComponents.AdministrativeAreaLevel1, @administrative_area_level_1_attrs)
      assert cq = Repo.get_by(AddressComponents.ColloquialArea, @colloquial_area_attrs)
      assert a2 = Repo.get_by(AddressComponents.AdministrativeAreaLevel2, @administrative_area_level_2_attrs)
      assert pc = Repo.get_by(AddressComponents.PostalCode, @postal_code_attrs)
      assert lt = Repo.get_by(AddressComponents.Locality, @locality_attrs)

      assert AddressComponents.has_administrative_area_level1_colloquial_areas(%{
        administrative_area_level_1_id: a1.id, colloquial_area_id: cq.id
      })
      assert AddressComponents.has_administrative_area_level1_administrative_area_level2s(%{
        administrative_area_level_1_id: a1.id, administrative_area_level_2_id: a2.id
      })
      assert AddressComponents.has_administrative_area_level1_postal_codes(%{
        administrative_area_level_1_id: a1.id, postal_code_id: pc.id
      })
      assert AddressComponents.has_administrative_area_level1_localities(%{
        administrative_area_level_1_id: a1.id, locality_id: lt.id
      })
      assert AddressComponents.has_colloquial_area_administrative_area_level2s(%{
        colloquial_area_id: cq.id, administrative_area_level_2_id: a2.id
      })
      assert AddressComponents.has_colloquial_area_postal_codes(%{
        colloquial_area_id: cq.id, postal_code_id: pc.id
      })
      assert AddressComponents.has_colloquial_area_localities(%{
        colloquial_area_id: cq.id, locality_id: lt.id
      })
      assert AddressComponents.has_administrative_area_level2_postal_codes(%{
        administrative_area_level_2_id: a2.id, postal_code_id: pc.id
      })
      assert AddressComponents.has_administrative_area_level2_localities(%{
        administrative_area_level_2_id: a2.id, locality_id: lt.id
      })
      assert AddressComponents.has_postal_code_localities(%{
        postal_code_id: pc.id, locality_id: lt.id
      })
    end
  end
end
