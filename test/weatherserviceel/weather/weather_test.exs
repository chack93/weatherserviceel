defmodule WSE.WeatherTest do
  """
  use WSE.DataCase

  alias WSE.Repo.LocationRepo

  describe "weather_locations" do
    alias WSE.Model.Location

    @valid_attrs %{active: true, name: "some name"}
    @update_attrs %{active: false, name: "some updated name"}
    @invalid_attrs %{active: nil, name: nil}

    def location_fixture(attrs \\ %{}) do
      {:ok, location} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LocationRepo.create_location()

      location
    end

    test "list_weather_locations/0 returns all weather_locations" do
      location = location_fixture()
      assert LocationRepo.list_weather_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert LocationRepo.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      assert {:ok, %Location{} = location} = LocationRepo.create_location(@valid_attrs)
      assert location.active == true
      assert location.name == "some name"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LocationRepo.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()
      assert {:ok, %Location{} = location} = LocationRepo.update_location(location, @update_attrs)
      assert location.active == false
      assert location.name == "some updated name"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = LocationRepo.update_location(location, @invalid_attrs)
      assert location == LocationRepo.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = LocationRepo.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> LocationRepo.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = LocationRepo.change_location(location)
    end
  end
  """
end
