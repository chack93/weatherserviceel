defmodule WSE.Model.CityListItem do

  @derive Jason.Encoder
  defstruct coordinate: nil, country: nil, id: nil, name: nil

  def map_file_item(item), do:
  %WSE.Model.CityListItem{
    coordinate: %WSE.Model.Coordinate{
      latitude: item["coord"]["lat"],
      longitude: item["coord"]["lon"]
    },
    country: item["country"],
    id: item["id"],
    name: item["name"]
  }
end
