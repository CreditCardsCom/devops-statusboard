defmodule Dashboard.Cache do
  def start_link do
    Agent.start_link(&Map.new/0, name: __MODULE__)
  end

  def get(backend) do
    Agent.get(__MODULE__, &Map.get(&1, backend))
  end

  def put(backend, value) do
    Agent.update(__MODULE__, &Map.put(&1, backend, value))
  end
end
