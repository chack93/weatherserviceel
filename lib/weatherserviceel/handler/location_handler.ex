defmodule WSE.Handler.LocationHandler do

  alias WSE.Model.Location
  alias WSE.Handler.RequestLimiter

  @doc """
  Simple location query. Returns a Task to be awaited.
  iex> Task.await(WSE.Handler.LocationHandler.location_by_query("query", "lang"))
  %Location{...}
  """
  def location_by_query(query, lang \\ nil), do:
    RequestLimiter.schedule_next(
      fn ->
        with {:ok, %{body: body, status: status}} <- WSE.Api.OpenWeatherMap.current_weather_by_query(query, lang) do
          if status != 200, do: raise WSE.Model.Error.Internal
          Map.put(body, "languageKey", lang)
          |> WSE.Model.Location.map_api_response
        end
      end
    )
end
