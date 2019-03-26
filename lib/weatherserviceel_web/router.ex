defmodule WSEWeb.Router do
  use WSEWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WSEWeb do
    pipe_through :api

    resources "/location", LocationController, except: [:new, :edit]
  end
end
