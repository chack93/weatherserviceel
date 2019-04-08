defmodule WSE.Repo.LocationList do
  use Agent
  alias WSE.Model.Coordinate
  alias WSE.Model.CityListItem

  def start_link(_opts) do
    Agent.start_link(
      fn ->
        Path.join(:code.priv_dir(:weatherserviceel), "city-list.json")
        |> File.read!
        |> Jason.decode!
        |> Stream.map(&CityListItem.map_file_item/1)
        |> Enum.to_list
      end,
      name: __MODULE__
    )
  end

  def find_nearby(%Coordinate{} = coordinate) do
    tolerance = Application.get_env(:weatherserviceel, :app_config)[:coordinate_search_tolerance]
    requestedLati = coordinate.latitude
    requestedLong = coordinate.longitude

    Agent.get(__MODULE__, & &1)
    |> Stream.filter(
         fn items ->
           thisLati = items.coordinate.latitude
           thisLong = items.coordinate.longitude

           (requestedLati - tolerance) < thisLati and
           thisLati < (requestedLati + tolerance) and
           (requestedLong - tolerance) < thisLong and
           thisLong < (requestedLong + tolerance)
         end
       )
    |> Enum.to_list
  end
end
