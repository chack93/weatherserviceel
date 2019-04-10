defmodule WSE.Model.Condition do
  alias WSE.Utility

  @derive Jason.Encoder
  defstruct title: "",
            description: "",
            iconKey: "",
            temperatureK: 0.0,
            temperatureC: 0.0,
            temperatureF: 0.0,
            temperatureMinK: 0.0,
            temperatureMinC: 0.0,
            temperatureMinF: 0.0,
            temperatureMaxK: 0.0,
            temperatureMaxC: 0.0,
            temperatureMaxF: 0.0,
            humidity: 0.0,
            pressure: 0.0,
            pressureSea: 0.0,
            pressureGround: 0.0,
            windSpeed: 0.0,
            windDegree: 0.0,
            cloudiness: 0.0,
            rainLastHour: 0.0,
            rainLast3Hour: 0.0,
            snowLastHour: 0.0,
            snowLast3Hour: 0.0,
            visibility: 0.0,
            time: DateTime.utc_now()

  def map_api_response(ar), do:
  %WSE.Model.Condition{
    title: hd(ar["weather"])["main"] || "Unknown",
    description: hd(ar["weather"])["description"] || "Unknown",
    iconKey: hd(ar["weather"])["icon"] || "na",
    temperatureK: ar["main"]["temp"]
                  |> Float.round(2),
    temperatureC: ar["main"]["temp"]
                  |> Utility.toCelsius
                  |> Float.round(2),
    temperatureF: ar["main"]["temp"]
                  |> Utility.toFahrenheit
                  |> Float.round(2),
    temperatureMinK: ar["main"]["temp_min"]
                     |> Float.round(2),
    temperatureMinC: ar["main"]["temp_min"]
                     |> Utility.toCelsius
                     |> Float.round(2),
    temperatureMinF: ar["main"]["temp_min"]
                     |> Utility.toFahrenheit
                     |> Float.round(2),
    temperatureMaxK: ar["main"]["temp_max"]
                     |> Float.round(2),
    temperatureMaxC: ar["main"]["temp_max"]
                     |> Utility.toCelsius
                     |> Float.round(2),
    temperatureMaxF: ar["main"]["temp_max"]
                     |> Utility.toFahrenheit
                     |> Float.round(2),
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
