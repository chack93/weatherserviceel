defmodule WSE.Model.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias WSE.Model.Coordinate
  alias WSE.Model.Condition
  alias WSE.Model.Forecast

  @collection "weatherDataEl"
  def collection, do: @collection
  @keys [
    :id,
    :locationId,
    :name,
    :fetchLanguageKey,
    :coordinate,
    :countryCode,
    :city,
    :weatherCondition,
    :forecast,
    :sunrise,
    :sunset,
    :lastConditionUpdateTs,
    :lastForecastUpdateTs,
    :fetchSuccessFlag
  ]

  @derive {
    Jason.Encoder,
    only: @keys
  }
  @primary_key {:id, :binary_id, autogenerate: true}
  schema @collection do
    field :locationId, :integer, default: ""
    field :name, :string, default: ""
    field :fetchLanguageKey, :string, default: "en"
    field :coordinate,
          :map,
          default: %Coordinate{
            latitude: 0.0,
            longitude: 0.0
          }
    field :countryCode, :string, default: ""
    field :city, :string, default: ""
    field :weatherCondition, :map, default: nil
    field :forecast, {:array, :map}, default: []
    field :sunrise, :utc_datetime, default: DateTime.utc_now()
    field :sunset, :utc_datetime, default: DateTime.utc_now()
    field :lastConditionUpdateTs, :utc_datetime, default: nil
    field :lastForecastUpdateTs, :utc_datetime, default: nil
    field :fetchSuccessFlag, :boolean, default: nil
  end

  def changeset(location, params) do
    location
    |> cast(
         params,
         @keys
       )
    |> validate_required([:locationId])
  end

  def map_api_response(ar), do:
  %WSE.Model.Location{
    locationId: ar["id"],
    name: ar["name"],
    fetchLanguageKey: ar["languageKey"],
    coordinate: %Coordinate{
      latitude: ar["coord"]["lat"],
      longitude: ar["coord"]["lon"]
    },
    countryCode: ar["sys"]["country"],
    city: ar["name"],
    weatherCondition: Condition.map_api_response(ar),
    forecast: Forecast.map_api_response(ar),
    sunrise: ar["sys"]["sunrise"]
             |> DateTime.from_unix!,
    sunset: ar["sys"]["sunset"]
            |> DateTime.from_unix!,
    lastConditionUpdateTs: nil,
    lastForecastUpdateTs: nil,
    fetchSuccessFlag: nil
  }
end
