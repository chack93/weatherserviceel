defmodule WSEWeb.LocationControllerTest do
  use WSEWeb.ConnCase

  alias WSE.Model.Location

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "location search" do
    test "simple location search", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location, "north pole", lang: "de"))
      location = json_response(conn, 200)
      assert String.downcase(location["city"]) == "north pole"
      assert location["coordinate"] != nil
      assert location["countryCode"] != nil
      assert location["fetchLanguageKey"] == "de"
      assert location["forecast"] != nil
      assert is_integer location["locationId"]
      assert String.downcase(location["name"]) == "north pole"
      assert location["sunrise"] != nil
      assert location["sunset"] != nil
      assert location["weatherCondition"] != nil
    end
    test "improved location search", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location_v2, "sao paulo", country: "Brazil"))
      locations = json_response(conn, 200)
      [%{"origin" => first_origin, "weatherLocationNearby" => nearby_first_result} | tail] = locations
      assert is_list first_origin["boundingbox"]
      assert is_bitstring first_origin["category"]
      assert is_bitstring first_origin["display_name"]
      assert is_bitstring first_origin["icon"]
      assert first_origin["importance"] != nil
      assert first_origin["lat"] != nil
      assert is_bitstring first_origin["licence"]
      assert first_origin["lon"] != nil
      assert is_number first_origin["osm_id"]
      assert is_bitstring first_origin["osm_type"]
      assert is_number first_origin["place_id"]
      assert is_number first_origin["place_rank"]
      assert is_bitstring first_origin["type"]
      assert length(locations) > 0
      assert length(nearby_first_result) > 0
    end
    test "location search by id", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location_by_id, 5870294))
      location = json_response(conn, 200)
      assert "north pole" == String.downcase(location["city"])
      assert location["coordinate"] != nil
      assert location["countryCode"] != nil
      assert location["fetchLanguageKey"] == nil
      assert location["forecast"] != nil
      assert is_integer location["locationId"]
      assert "north pole" == String.downcase(location["name"])
      assert location["sunrise"] != nil
      assert location["sunset"] != nil
      assert location["weatherCondition"] != nil
    end
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
