use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weatherserviceel, WSEWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :weatherserviceel,
       :mongodb_connection,
       url: "mongodb://nucsrv.lan:27017/weatherservice-test"

# Speed up bcrypt
config :bcrypt_elixir, :log_rounds, 4
