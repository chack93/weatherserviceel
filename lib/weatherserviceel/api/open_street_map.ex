defmodule WSE.Api.OpenStreetMap do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://nominatim.openstreetmap.org"
  plug Tesla.Middleware.Headers, [{"user-agent", "Weatherservice Application"}]
  plug Tesla.Middleware.JSON

  def get_location(city, country \\ nil)do
    country_query = if (country != nil), do: "&country=#{URI.encode(country)}", else: ""
    get "/?city=#{URI.encode(city)}#{country_query}&format=jsonv2"
  end
end
