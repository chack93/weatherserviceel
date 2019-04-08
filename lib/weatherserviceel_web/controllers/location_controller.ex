defmodule WSEWeb.LocationController do
  use WSEWeb, :controller

  alias WSE.Model.Location
  alias WSE.Model.LocationRepo

  action_fallback WSEWeb.FallbackController

  def query_location(conn, %{"query" => query, "lang" => lang}) do
    location = Task.await(WSE.Handler.LocationHandler.location_by_query(query, lang), 30000)
    render(conn, "location.json", location: location)
  end
  def query_location(conn, %{"query" => query}), do:
    query_location(conn, %{"query" => query, "lang" => "en"})

  def query_location_v2(conn, %{"query" => query, "city" => city}) do
    locations = Task.await(WSE.Handler.LocationHandler.location_by_query_v2(query, city), 30000)
    render(conn, "augmented_location_index.json", locations: locations)
  end
  def query_location_v2(conn, %{"query" => query}), do:
    query_location_v2(conn, %{"query" => query, "city" => nil})

  def query_location_by_id(conn, %{"id" => id, "lang" => lang}) do
    location = Task.await(WSE.Handler.LocationHandler.location_by_id(id, lang), 30000)
    render(conn, "location.json", location: location)
  end
  def query_location_by_id(conn, %{"id" => id}), do:
    query_location_by_id(conn, %{"id" => id, "lang" => nil})

  def index(conn, _param), do: %{}
  def show(conn, _param), do: %{}
  def create(conn, _param), do: %{}
  def update(conn, _param), do: %{}
  def delete(conn, _param), do: %{}
  def trigger_refresh(conn, _param), do: %{}

  """
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
  """
end
