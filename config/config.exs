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
       metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
