defmodule WSE.Utility do
  def toCelsius(kelvin), do: kelvin - 273.15
  def toFahrenheit(kelvin), do: toCelsius(kelvin) * 1.8 + 32
end
