defmodule WSE.Model.Forecast do
  alias WSE.Model.Condition

  @derive Jason.Encoder
  defstruct date: DateTime.from_unix(0), condition: %Condition{}

  def map_api_response(api_response) do
    api_response["list"] || []
    |> Stream.map(
         fn condition ->
           %WSE.Model.Forecast{
             date: DateTime.from_unix!(condition["dt"]),
             condition: Condition.map_api_response(condition)
           }
         end
       )
    |> Enum.to_list
  end
end
