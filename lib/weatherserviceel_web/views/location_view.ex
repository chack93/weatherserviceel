defmodule WSEWeb.LocationView do
  use WSEWeb, :view
  alias WSEWeb.LocationView

  def render("location_index.json", %{locations: weather_locations}) do
    render_many(weather_locations, LocationView, "location.json")
  end
  def render("augmented_location_index.json", %{locations: augmented_locations}) do
    render_many(augmented_locations, LocationView, "augmented_location.json")
  end

  def render("location.json", %{location: location}) do
    location
  end

  def render("augmented_location.json", %{location: augmented_location}) do
    augmented_location
  end
end
