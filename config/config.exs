# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :weatherserviceel,
       :mongodb_connection,
       url: "mongodb://nucsrv.lan:27017/weatherservice"

config :weatherserviceel, WSE.Service.RefreshScheduler,
  jobs: [
    {"0 */1 * * *", {WSE.Service.RefreshScheduler, :refresh_weather_data, []}}
  ]

config :weatherserviceel,
       :app_config,
       owm_api_key: "",
       request_limiter_period_duration_in_sec: 1,
       request_limiter_req_per_sec: 1,
       coordinate_search_tolerance: 0.1,
       refresh_condition_interval_seconds: 43200,
       refresh_forecast_interval_seconds: 86400

# Configures the endpoint
config :weatherserviceel,
       WSEWeb.Endpoint,
       url: [
         host: "localhost"
       ],
       secret_key_base: "YgHl89EOG1FTqtj/xTL2squUpVjkqV4yiN31N+8u/zyNNztNZuIBF+SFJNsZdtgh",
       render_errors: [
         view: WSEWeb.ErrorView,
         accepts: ~w(json)
       ],
       pubsub: [
         name: WSE.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]

# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:request_id],
       level: :warn

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
