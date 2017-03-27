defmodule Dashboard.WorkerManager do
  use Supervisor

  alias Dashboard.Backend

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children =
      Backend.configured
      |> Enum.map(fn(backend) ->
        name = Atom.to_string(backend)
               |> String.replace("Backend", "Worker")
               |> String.to_atom()

        worker(Dashboard.Worker, [backend], id: name, name: name)
      end)

    supervise(children, strategy: :one_for_one)
  end
end
