defmodule WSE.Api.OpenWeatherMap do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://api.openweathermap.org/"
  plug Tesla.Middleware.JSON

  defp app_id, do:
    Application.get_env(:app_name, :app_config)[:owm_api_key]

  def current_weather_by_query(query, nil), do:
    get "/data/2.5/weather?q=#{query}&APPID=#{app_id}"
  def current_weather_by_query(query, lang), do:
    get "/data/2.5/weather?q=#{query}&lang=#{lang}&APPID=#{app_id}"

  def current_weather_by_id(id, nil), do:
    get "/data/2.5/weather?id=#{id}&APPID=#{app_id}"
  def current_weather_by_id(id, lang), do:
    get "/data/2.5/weather?id=#{id}&lang=#{lang}&APPID=#{app_id}"

  def weather_forecast_by_id(id, nil), do:
    get "/data/2.5/forecast?id=#{id}&APPID=#{app_id}"
  def weather_forecast_by_id(id, lang), do:
    get "/data/2.5/forecast?id=#{id}&lang=#{lang}&APPID=#{app_id}"
end
