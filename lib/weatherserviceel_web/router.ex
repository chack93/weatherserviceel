defmodule WSEWeb.Router do
  use WSEWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WSEWeb do
    pipe_through :api

    get "/v1/location/query/:query", LocationController, :query_location
    get "/v2/location/query/:query", LocationController, :query_location_v2
    get "/v1/location/query/id/:id", LocationController, :query_location_by_id
    get "/v1/location/index", LocationController, :index
    get "/v1/location/id/:id", LocationController, :show
    put "/v1/location/id/:id", LocationController, :create
    post "/v1/location/id/:id", LocationController, :update
    delete "/v1/location/id/:id", LocationController, :delete
    get "/v1/trigger-refresh", LocationController, :trigger_refresh
    get "/v1/statistic", LocationController, :statistic
  end
end
