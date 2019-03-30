defmodule WSE.Handler.WeatherLocation do

  alias WSE.Handler.RequestScheduler
  alias WSE.Weather.Location

  def query_location(query, lang \\ nil), do:
    RequestScheduler.schedule_next(
      fn ->
        WSE.Api.OpenWeatherMap.current_weather_by_query(query, lang)
        |> &Location.map_api_response(&1)
      end
    )
  #WSE.Api.OpenWeatherMap
  # 1. create api endpoint
  # 2. fetch location
  # 3. create limiter
end
