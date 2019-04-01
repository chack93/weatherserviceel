defmodule WSE.Model.Forecast do
  use Ecto.Schema
  alias WSE.Model.Condition

  @derive {Jason.Encoder, only: [:date, :condition]}
  @primary_key {:id, :id, autogenerate: false}
  schema "condition" do
    field :date, :utc_datetime, default: DateTime.from_unix(0)
    field :condition, {:map, %Condition{}}, default: nil
  end

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
