defmodule WSEWeb.LocationController do
  use WSEWeb, :controller

  alias WSE.Weather.Location
  alias WSE.Weather.LocationRepo

  action_fallback WSEWeb.FallbackController

  def index(conn, _params) do
    weather_locations = LocationRepo.list_weather_locations()
    render(conn, "index.json", weather_locations: weather_locations)
  end

  def create(conn, %{"location" => location_params}) do
    with {:ok, %Location{} = location} <- LocationRepo.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = LocationRepo.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = LocationRepo.get_location!(id)

    with {:ok, %Location{} = location} <- LocationRepo.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = LocationRepo.get_location!(id)

    with {:ok, %Location{}} <- LocationRepo.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
