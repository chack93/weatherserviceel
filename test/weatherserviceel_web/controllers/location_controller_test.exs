defmodule WSEWeb.LocationControllerTest do
  use WSEWeb.ConnCase

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
      assert is_integer(location["locationId"])
      assert String.downcase(location["name"]) == "north pole"
      assert location["sunrise"] != nil
      assert location["sunset"] != nil
      assert location["weatherCondition"] != nil
    end

    test "improved location search", %{conn: conn} do
      conn =
        get(conn, Routes.location_path(conn, :query_location_v2, "sao paulo", country: "Brazil"))

      locations = json_response(conn, 200)

      [%{"origin" => first_origin, "weatherLocationNearby" => nearby_first_result} | _tail] =
        locations

      assert is_list(first_origin["boundingbox"])
      assert is_bitstring(first_origin["category"])
      assert is_bitstring(first_origin["display_name"])
      assert is_bitstring(first_origin["icon"])
      assert first_origin["importance"] != nil
      assert first_origin["lat"] != nil
      assert is_bitstring(first_origin["licence"])
      assert first_origin["lon"] != nil
      assert is_number(first_origin["osm_id"])
      assert is_bitstring(first_origin["osm_type"])
      assert is_number(first_origin["place_id"])
      assert is_number(first_origin["place_rank"])
      assert is_bitstring(first_origin["type"])
      assert length(locations) > 0
      assert length(nearby_first_result) > 0
    end

    test "location search by id", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :query_location_by_id, 5_870_294))
      location = json_response(conn, 200)
      assert "north pole" == String.downcase(location["city"])
      assert location["coordinate"] != nil
      assert location["countryCode"] != nil
      assert location["fetchLanguageKey"] == nil
      assert location["forecast"] != nil
      assert is_integer(location["locationId"])
      assert "north pole" == String.downcase(location["name"])
      assert location["sunrise"] != nil
      assert location["sunset"] != nil
      assert location["weatherCondition"] != nil
    end
  end

  describe "add, modify, delete location by id 5870294 - north pole" do
    test "add, get, modify, delete 5870294 in order", %{conn: conn} do
      IO.puts("delete location if any")
      delete(conn, Routes.location_path(conn, :delete, "5870294"))

      assert_error_sent 404, fn ->
        get(conn, Routes.location_path(conn, :show, "5870294"))
      end

      IO.puts("add location")
      r_conn = put(conn, Routes.location_path(conn, :create, "5870294", lang: "en"))
      locationAdd = json_response(r_conn, 200)
      assert "north pole" == String.downcase(locationAdd["city"])
      assert 5_870_294 == locationAdd["locationId"]
      assert "en" == String.downcase(locationAdd["fetchLanguageKey"])

      IO.puts("add again & expect error")

      assert_error_sent 400, fn ->
        put(conn, Routes.location_path(conn, :create, "5870294", lang: "en"))
      end

      IO.puts("modify fetch language")
      r_conn = post(conn, Routes.location_path(conn, :update, "5870294", lang: "de"))
      locationPost = json_response(r_conn, 200)
      assert "north pole" == String.downcase(locationPost["city"])
      assert 5_870_294 == locationPost["locationId"]
      assert "de" == String.downcase(locationPost["fetchLanguageKey"])
      assert "north pole" == String.downcase(locationPost["city"])

      IO.puts("get location & check modification")
      r_conn = get(conn, Routes.location_path(conn, :show, "5870294"))
      locationGet = json_response(r_conn, 200)
      assert "north pole" == String.downcase(locationGet["city"])
      assert 5_870_294 == locationGet["locationId"]
      assert "de" == String.downcase(locationGet["fetchLanguageKey"])
      assert "north pole" == String.downcase(locationGet["city"])

      IO.puts("get location index")
      r_conn = get(conn, Routes.location_path(conn, :index))
      locationIndexList = json_response(r_conn, 200)
      assert [locationIndexFirst] = locationIndexList
      assert "north pole" == String.downcase(locationIndexFirst["city"])
      assert 5_870_294 == locationIndexFirst["locationId"]
      assert "de" == String.downcase(locationIndexFirst["fetchLanguageKey"])
      assert "north pole" == String.downcase(locationIndexFirst["city"])

      IO.puts("delete location")
      r_conn = delete(conn, Routes.location_path(conn, :delete, "5870294"))
      response(r_conn, 200)

      assert_error_sent 404, fn ->
        get(conn, Routes.location_path(conn, :show, "5870294"))
      end
    end
  end
end
