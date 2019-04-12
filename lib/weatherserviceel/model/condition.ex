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

  def map_api_response(ar),
    do: %WSE.Model.Condition{
      title: hd(ar["weather"])["main"] || "Unknown",
      description: hd(ar["weather"])["description"] || "Unknown",
      iconKey: hd(ar["weather"])["icon"] || "na",
      temperatureK:
        ar["main"]["temp"]
        |> round_2_digit,
      temperatureC:
        ar["main"]["temp"]
        |> Utility.toCelsius()
        |> round_2_digit,
      temperatureF:
        ar["main"]["temp"]
        |> Utility.toFahrenheit()
        |> round_2_digit,
      temperatureMinK:
        ar["main"]["temp_min"]
        |> round_2_digit,
      temperatureMinC:
        ar["main"]["temp_min"]
        |> Utility.toCelsius()
        |> round_2_digit,
      temperatureMinF:
        ar["main"]["temp_min"]
        |> Utility.toFahrenheit()
        |> round_2_digit,
      temperatureMaxK:
        ar["main"]["temp_max"]
        |> round_2_digit,
      temperatureMaxC:
        ar["main"]["temp_max"]
        |> Utility.toCelsius()
        |> round_2_digit,
      temperatureMaxF:
        ar["main"]["temp_max"]
        |> Utility.toFahrenheit()
        |> round_2_digit,
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
      visibility: (ar["visibility"] || 0.0) + 0.0,
      time: DateTime.from_unix!(ar["dt"])
    }

  defp round_2_digit(nil), do: 0.0
  defp round_2_digit(float), do: Float.round(float + 0.0, 2)
end
