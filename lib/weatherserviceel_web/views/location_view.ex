defmodule WSEWeb.LocationView do
  use WSEWeb, :view
  alias WSEWeb.LocationView

  def render("index.json", %{weather_locations: weather_locations}) do
    %{data: render_many(weather_locations, LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      name: location.name,
      active: location.active}
  end
end
