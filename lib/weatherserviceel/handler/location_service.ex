defmodule WSE.Service.LocationService do
  alias WSE.Model.Location
  alias WSE.Model.Forecast
  alias WSE.Model.Coordinate
  alias WSE.Model.ImprovedLocation
  alias WSE.Service.RequestLimiter

  @doc """
  Simple location query. Returns a Task to be awaited.
  iex> Task.await(WSE.Service.LocationService.location_by_query!("query", "lang"))
  %Location{...}
  """
  def location_by_query!(query, lang \\ nil),
    do:
      RequestLimiter.schedule_next(fn ->
        with {:ok, %{body: body, status: status}} <-
               WSE.Api.OpenWeatherMap.current_weather_by_query(query, lang) do
          if status != 200, do: raise(WSE.Model.Error.Internal)

          Map.put(body, "languageKey", lang)
          |> Location.map_api_response()
        end
      end)

  @doc """
  Get location by id. Returns a Task to be awaited.
  iex> Task.await(WSE.Service.LocationService.location_by_id!(1234, "lang"))
  %Location{...}
  """
  def location_by_id!(id, lang \\ nil),
    do:
      RequestLimiter.schedule_next(fn ->
        with {:ok, %{body: body, status: status}} <-
               WSE.Api.OpenWeatherMap.current_weather_by_id(id, lang) do
          if status != 200, do: raise(WSE.Model.Error.Internal)

          Map.put(body, "languageKey", lang)
          |> Location.map_api_response()
        end
      end)

  @doc """
  Get a location's forecast. Returns a Task to be awaited.
  iex> Task.await(WSE.Service.LocationService.forecast_by_id!(1234, "lang"))
  [%Forecast{}, ...]
  """
  def forecast_by_id!(id, lang \\ nil),
    do:
      RequestLimiter.schedule_next(fn ->
        with {:ok, %{body: body, status: status}} <-
               WSE.Api.OpenWeatherMap.weather_forecast_by_id(id, lang) do
          if status != 200, do: raise(WSE.Model.Error.Internal)

          Forecast.map_api_response(body)
        end
      end)

  @doc """
  Improved location search. Returns a Task to be awaited.
  Returns up to 5 locations matching city/country query & within each, up to 3 weather location nearby.
  iex> Task.await(WSE.Service.LocationService.location_by_query_v2!("city", "country"))
  %Location{...}
  """
  def location_by_query_v2!(city, country \\ nil),
    do:
      RequestLimiter.schedule_next(fn ->
        with {:ok, %{body: body, status: status}} <-
               WSE.Api.OpenStreetMap.get_location(city, country) do
          if status != 200, do: raise(WSE.Model.Error.Internal)

          body
          |> WSE.Model.OsmLocation.map_api_response_list()
          |> Enum.slice(0..4)
          |> Stream.map(fn originLoc ->
            {latitude, _} = Float.parse(originLoc.lat)
            {longitude, _} = Float.parse(originLoc.lon)
            originCoordinate = %Coordinate{latitude: latitude, longitude: longitude}

            WSE.Repo.LocationList.find_nearby(originCoordinate)
            |> Enum.slice(0..2)
            |> Enum.sort(fn a, b ->
              get_score(originCoordinate, a.coordinate) <
                get_score(originCoordinate, b.coordinate)
            end)
            |> Enum.to_list()
            |> (&%ImprovedLocation{origin: originLoc, weatherLocationNearby: &1}).()
          end)
          |> Enum.to_list()
        end
      end)

  defp get_score(
         %Coordinate{latitude: originLatitude, longitude: originLongitude},
         %Coordinate{latitude: latitude, longitude: longitude}
       ),
       do: (abs(originLatitude - latitude) + abs(originLongitude - longitude)) * 10_000_000
end
