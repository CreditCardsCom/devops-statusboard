defmodule Dashboard.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(Dashboard.Web.Endpoint, []),
      # Start the cache store prior to loading workers
      worker(Dashboard.Cache, []),
      supervisor(Dashboard.WorkerManager, [])
    ]

    # TODO: move this out into a worker init function or the like
    :ets.new(Dashboard.Backend.TravisCI, [:named_table, :public])

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
