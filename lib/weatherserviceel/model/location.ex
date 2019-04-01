defmodule WSE.Model.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias WSE.Model.Coordinate
  alias WSE.Model.Condition
  alias WSE.Model.Forecast

  @collection "weatherDataEl"
  def collection, do: @collection

  @derive {Jason.Encoder, only: [:locationId, :name, :fetchLanguageKey, :coordinate, :countryCode, :city, :weatherCondition, :forecast, :sunrise, :sunset, :lastConditionUpdateTs, :lastForecastUpdateTs, :fetchSuccessFlag]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema @collection do
    field :locationId, :string, default: ""
    field :name, :string, default: ""
    field :fetchLanguageKey, :string, default: "en"
    field :coordinate,
          {:map, %Coordinate{}},
          default: %Coordinate{
            latitude: 0.0,
            longitude: 0.0
          }
    field :countryCode, :string, default: ""
    field :city, :string, default: ""
    field :weatherCondition, {:array, %Condition{}}, default: nil
    field :forecast, {:array, %Forecast{}}, default: []
    field :sunrise, :integer, default: 0
    field :sunset, :integer, default: 0
    field :lastConditionUpdateTs, :utc_datetime, default: nil
    field :lastForecastUpdateTs, :utc_datetime, default: nil
    field :fetchSuccessFlag, :boolean, default: nil
    timestamps()
  end

  def changeset(location, attrs) do
    location
    |> cast(
         attrs,
         [
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
           :fetchSuccessFlag,
         ]
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
    sunrise: ar["sys"]["sunrise"] |> DateTime.from_unix!,
    sunset: ar["sys"]["sunset"] |> DateTime.from_unix!,
    lastConditionUpdateTs: nil,
    lastForecastUpdateTs: nil,
    fetchSuccessFlag: nil
  }
end
