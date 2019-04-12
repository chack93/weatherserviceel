defmodule WSE.Model.Forecast do
  alias WSE.Model.Condition

  @derive Jason.Encoder
  defstruct date: DateTime.from_unix(0), condition: %Condition{}

  def map_api_response(nil), do: []

  def map_api_response(api_response) do
    (api_response["list"] || [])
    |> Stream.map(fn condition ->
      %WSE.Model.Forecast{
        date: DateTime.from_unix!(condition["dt"]),
        condition: Condition.map_api_response(condition)
      }
    end)
    |> Enum.to_list()
  end

  def to_map(nil), do: []

  def to_map(forecast_list) when is_list(forecast_list),
    do:
      forecast_list
      |> Stream.map(fn fc ->
        to_map(fc)
      end)
      |> Enum.to_list()

  def to_map(forecast) do
    forecast
    |> Map.put(:condition, Map.from_struct(forecast.condition || %Condition{}))
    |> Map.from_struct()
  end
end
