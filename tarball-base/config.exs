use Mix.Config

config :weatherserviceel,
       :mongodb_connection,
       url: "mongodb://mongodb.jail:27017/weatherserviceEl"

config :weatherserviceel, WSEWeb.Endpoint,
  http: [port: 8080],
  url: [host: "localhost", port: 8080]

config :weatherserviceel,
  :app_config,
  owm_api_key: "",
  request_limiter_period_duration_in_sec: 1,
  request_limiter_req_per_sec: 1,
  coordinate_search_tolerance: 0.1,
  refresh_condition_interval_seconds: 43200,
  refresh_forecast_interval_seconds: 86400

config :logger, level: :info

