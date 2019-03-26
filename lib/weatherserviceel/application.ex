defmodule WSE.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      worker(
        Mongo,
        [
          [
            name: :mongodb_pool,
            url: Application.get_env(:weatherserviceel, :mongodb_connection)[:url],
            pool: DBConnection.Poolboy
          ]
        ]
      ),
      # Start the endpoint when the application starts
      WSEWeb.Endpoint
      # Starts a worker by calling: WSE.Worker.start_link(arg)
      # {WSE.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WSE.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WSEWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
