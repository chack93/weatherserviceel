defmodule WSE.Model.OsmLocation do
  @derive Jason.Encoder
  defstruct place_id: nil,
            licence: nil,
            osm_type: nil,
            osm_id: nil,
            boundingbox: nil,
            lat: nil,
            lon: nil,
            display_name: nil,
            place_rank: nil,
            category: nil,
            type: nil,
            importance: nil,
            icon: nil

  def map_api_response_list(list),
    do:
      Stream.map(list, &map_api_response(&1))
      |> Enum.to_list()

  def map_api_response(ar),
    do: %WSE.Model.OsmLocation{
      place_id: ar["place_id"],
      licence: ar["licence"],
      osm_type: ar["osm_type"],
      osm_id: ar["osm_id"],
      boundingbox: ar["boundingbox"],
      lat: ar["lat"],
      lon: ar["lon"],
      display_name: ar["display_name"],
      place_rank: ar["place_rank"],
      category: ar["category"],
      type: ar["type"],
      importance: ar["importance"],
      icon: ar["icon"]
    }
end
