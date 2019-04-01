defmodule WSE.Api.OpenStreetMap do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://api.openweathermap.org/"
  plug Tesla.Middleware.Headers, [{"authorization", "token xyz"}]
  plug Tesla.Middleware.JSON

  def user_repos(login) do
    get("/user/" <> login <> "/repos")
  end
end
