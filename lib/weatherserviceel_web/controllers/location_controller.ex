defmodule WSEWeb.LocationController do
  use WSEWeb, :controller

  alias WSE.Repo.LocationRepo
  alias WSE.Service.LocationService

  action_fallback WSEWeb.FallbackController

  def query_location(conn, %{"query" => query, "lang" => lang}) do
    location = Task.await(LocationService.location_by_query!(query, lang), 30000)
    render(conn, "location.json", location: location)
  end

  def query_location(conn, %{"query" => query}),
    do: query_location(conn, %{"query" => query, "lang" => "en"})

  def query_location_v2(conn, %{"query" => query, "city" => city}) do
    locations = Task.await(LocationService.location_by_query_v2!(query, city), 30000)
    render(conn, "augmented_location_index.json", locations: locations)
  end

  def query_location_v2(conn, %{"query" => query}),
    do: query_location_v2(conn, %{"query" => query, "city" => nil})

  def query_location_by_id(conn, %{"id" => id, "lang" => lang}) do
    location = Task.await(LocationService.location_by_id!(id, lang), 30000)
    render(conn, "location.json", location: location)
  end

  def query_location_by_id(conn, %{"id" => id}),
    do: query_location_by_id(conn, %{"id" => id, "lang" => nil})

  def index(conn, _param) do
    location = LocationRepo.list_weather_locations()
    render(conn, "location.json", location: location)
  end

  def show(conn, %{"id" => id}) do
    {location_id, _} = Integer.parse(id)
    location = LocationRepo.get_location!(location_id)
    render(conn, "location.json", location: location)
  end

  def create(conn, %{"id" => location_id, "lang" => lang}) do
    location = Task.await(LocationService.location_by_id!(location_id, lang), 30000)
    {:ok, new_location} = LocationRepo.create_location(location)
    render(conn, "location.json", location: new_location)
  end

  def create(conn, %{"id" => location_id}),
    do: create(conn, %{"id" => location_id, "lang" => nil})

  def update(conn, %{"id" => id, "lang" => lang}) do
    {location_id, _} = Integer.parse(id)
    location = LocationRepo.get_location!(location_id)

    case LocationRepo.update_location(location, %{fetchLanguageKey: lang}) do
      {:ok, new_location} -> render(conn, "location.json", location: new_location)
      _ -> raise WSE.Model.Error.BadRequest
    end
  end

  def delete(conn, %{"id" => id}) do
    {location_id, _} = Integer.parse(id)
    {:ok, location} = LocationRepo.delete_location(location_id)

    if location == nil,
      do: put_status(conn, :not_found),
      else: render(conn, "location.json", location: location)
  end

  def trigger_refresh(conn, _param) do
    WSE.Service.RefreshScheduler.refresh_weather_data()
    render(conn, "empty.json")
  end
end
