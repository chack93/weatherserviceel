defmodule WSE.Api.OpenWeatherMap do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://api.openweathermap.org/"
  plug Tesla.Middleware.JSON

  def current_weather_by_query(query, lang \\ nil), do:
    get "/data/2.5/weather?q=#{query}#{lang_query(lang)}&APPID=#{app_id()}"

  def current_weather_by_id(id, lang \\ nil), do:
    get "/data/2.5/weather?id=#{id}#{lang_query(lang)}&APPID=#{app_id()}"

  def weather_forecast_by_id(id, lang \\ nil), do:
    get "/data/2.5/forecast?id=#{id}#{lang_query(lang)}&APPID=#{app_id()}"

  defp app_id, do:
    Application.get_env(:weatherserviceel, :app_config)[:owm_api_key]

  defp lang_query(lang), do:
    if lang, do: "&lang=#{lang}", else: ""
end
