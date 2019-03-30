defmodule WSE.Api.OpenWeatherMap do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://api.openweathermap.org/"
  #plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON

  def user_repos(login) do
    get("/user/" <> login <> "/repos")
  end
end


@Client("http://api.openweathermap.org/")
interface OpenWeatherMapClient {

@Get("/data/2.5/weather{?q,lang}{&APPID}")
                                         fun getCurrentWeatherByQuery(q: String?, lang: String?, APPID: String?): Single<WApiCurrentWeather>

                                                                                                                        @Get("/data/2.5/weather{?id,lang}{&APPID}")
fun getCurrentWeatherById(id: String?, lang: String?, APPID: String?): Single<WApiCurrentWeather>

                                                                              @Get("/data/2.5/forecast{?id,lang}{&APPID}")
fun getWeatherForecastById(id: String?, lang: String?, APPID: String?): Single<WApiForecast>

}
