use Mix.Config

config :weatherserviceel, WSEWeb.Endpoint,
  http: [port: 7030],
  url: [host: "nucsrv.lan", port: 7030],
  server: true

config :weatherserviceel,
     :app_config,
     owm_api_key: "",
     request_limiter_period_duration_in_sec: 1,
     request_limiter_req_per_sec: 1,
     coordinate_search_tolerance: 0.1,
     refresh_condition_interval_seconds: 43200,
     refresh_forecast_interval_seconds: 86400

config :logger, level: :info

import_config "prod.secret.exs"
