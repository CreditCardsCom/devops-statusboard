defmodule Dashboard.Pingdom.Supervisor do
  use Supervisor, restart: :permanent

  alias Dashboard.Pingdom.Fetcher
  alias Dashboard.Pingdom.Site

  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Site.fetch_sites()
    |> Enum.map(&({Fetcher, &1}))
    |> Supervisor.init(strategy: :one_for_one)
  end
end
