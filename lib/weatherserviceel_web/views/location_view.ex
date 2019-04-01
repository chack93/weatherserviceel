defmodule WSEWeb.LocationView do
  use WSEWeb, :view
  alias WSEWeb.LocationView

  def render("location_index.json", %{weather_locations: weather_locations}) do
    %{data: render_many(weather_locations, LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    location
  end
end
