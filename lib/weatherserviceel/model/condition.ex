defmodule WSE.Model.Condition do
  use Ecto.Schema
  alias WSE.Utility

  @derive {Jason.Encoder, only: [:id, :title, :description, :iconKey, :temperatureK, :temperatureC, :temperatureF, :temperatureMinK, :temperatureMinC, :temperatureMinF, :temperatureMaxK, :temperatureMaxC, :temperatureMaxF, :humidity, :pressure, :pressureSea, :pressureGround, :windSpeed, :windDegree, :cloudiness, :rainLastHour, :rainLast3Hour, :snowLastHour, :snowLast3Hour, :visibility, :time]}
  @primary_key {:id, :id, autogenerate: false}
  schema "condition" do
    field :title, :string, default: ""
    field :description, :string, default: ""
    field :iconKey, :string, default: ""
    field :temperatureK, :float, default: 0.0
    field :temperatureC, :float, default: 0.0
    field :temperatureF, :float, default: 0.0
    field :temperatureMinK, :float, default: 0.0
    field :temperatureMinC, :float, default: 0.0
    field :temperatureMinF, :float, default: 0.0
    field :temperatureMaxK, :float, default: 0.0
    field :temperatureMaxC, :float, default: 0.0
    field :temperatureMaxF, :float, default: 0.0
    field :humidity, :float, default: 0.0
    field :pressure, :float, default: 0.0
    field :pressureSea, :float, default: 0.0
    field :pressureGround, :float, default: 0.0
    field :windSpeed, :float, default: 0.0
    field :windDegree, :float, default: 0.0
    field :cloudiness, :float, default: 0.0
    field :rainLastHour, :float, default: 0.0
    field :rainLast3Hour, :float, default: 0.0
    field :snowLastHour, :float, default: 0.0
    field :snowLast3Hour, :float, default: 0.0
    field :visibility, :float, default: 0.0
    field :time, :utc_datetime, default: DateTime.utc_now()
  end

  def map_api_response(ar), do:
  %WSE.Model.Condition{
    title: hd(ar["weather"])["main"] || "Unknown",
    description: hd(ar["weather"])["description"] || "Unknown",
    iconKey: hd(ar["weather"])["icon"] || "na",
    temperatureK: ar["main"]["temp"] |> Float.round(2),
    temperatureC: ar["main"]["temp"] |> Utility.toCelsius |> Float.round(2),
    temperatureF: ar["main"]["temp"] |> Utility.toFahrenheit |> Float.round(2),
    temperatureMinK: ar["main"]["temp_min"] |> Float.round(2),
    temperatureMinC: ar["main"]["temp_min"] |> Utility.toCelsius |> Float.round(2),
    temperatureMinF: ar["main"]["temp_min"] |> Utility.toFahrenheit |> Float.round(2),
    temperatureMaxK: ar["main"]["temp_max"] |> Float.round(2),
    temperatureMaxC: ar["main"]["temp_max"] |> Utility.toCelsius |> Float.round(2),
    temperatureMaxF: ar["main"]["temp_max"] |> Utility.toFahrenheit |> Float.round(2),
    humidity: ar["main"]["humidity"],
    pressure: ar["main"]["pressure"],
    pressureSea: ar["main"]["sea_level"] || ar["main"]["pressure"],
    pressureGround: ar["main"]["grnd_level"] || ar["main"]["pressure"],
    windSpeed: ar["wind"]["speed"],
    windDegree: ar["wind"]["deg"],
    cloudiness: ar["clouds"]["all"],
    rainLastHour: ar["rain"]["1h"],
    rainLast3Hour: ar["rain"]["3h"],
    snowLastHour: ar["snow"]["1h"],
    snowLast3Hour: ar["snow"]["3h"],
    visibility: ar["visibility"] + 0.0,
    time: DateTime.from_unix!(ar["dt"])
  }
end
