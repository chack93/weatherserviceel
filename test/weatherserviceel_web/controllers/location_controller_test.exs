defmodule WSEWeb.LocationControllerTest do
  use WSEWeb.ConnCase

  alias WSE.Weather.Location
  alias WSE.Weather.LocationRepo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "location search" do
    test "simple location search", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location, "north pole", lang: "de"))
      location = json_response(conn, 200)
      assert %Location{} = location
      assert "north pole" == String.downcase(location.name)
    end
"""
    test "improved location search", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location_v2, "sao paulo", country: "Brazil"))
      locations = json_response(conn, 200)
      assert [%Location{}] = locations
      assert length(locations) > 0
    end
    test "location search by id", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location_by_id, 5870294))
      location = json_response(conn, 200)
      assert %Location{} = location
      assert "north pole" == String.downcase(location.name)
    end
"""
  end

"""
  describe "add, modify, delete location by id 5870294 - north pole" do
    test "add,get,modify,delete 5870294 in order", %{conn: conn} do
      # delete location if any
      conn = delete(conn, Routes.location_path(conn, :delete, "5870294"))
      response(conn, 200)
      assert_error_sent 404, fn ->
        get(conn, Routes.location_path(conn, :show, "5870294"))
      end

      # add location
      conn = put(conn, Routes.location_path(conn, :create, "5870294", lang: "en"))
      locationAdd = json_response(conn, 200)
      assert %Location{} = locationAdd
      assert "en" == String.downcase(locationAdd.fetchLanguageKey)

      # add again & expect error
      conn = put(conn, Routes.location_path(conn, :create, "5870294", lang: "en"))
      response(conn, 400)

      # modify fetch language
      conn = post(conn, Routes.location_path(conn, :update, "5870294", lang: "de"))
      locationPost = json_response(conn, 200)
      assert %Location{} = locationPost
      assert "de" == String.downcase(locationPost.fetchLanguageKey)
      assert "north pole" == String.downcase(locationPost.name)

      # get location & check modification
      conn = get(conn, Routes.location_path(conn, :update, "5870294"))
      locationGet = json_response(conn, 200)
      assert %Location{} = locationGet
      assert "de" == String.downcase(locationGet.fetchLanguageKey)
      assert "north pole" == String.downcase(locationGet.name)

      # get location index
      conn = get(conn, Routes.location_path(conn, :index))
      locationIndexList = json_response(conn, 200)
      assert [%Location{}] = locationIndexList
      assert "de" == String.downcase(locationIndexList.fetchLanguageKey)
      assert "north pole" == String.downcase(locationIndexList.name)

      # delete location
      conn = delete(conn, Routes.location_path(conn, :delete, "5870294"))
      response(conn, 200)
      assert_error_sent 404, fn ->
        get(conn, Routes.location_path(conn, :show, "5870294"))
      end
    end
  end
"""
end
