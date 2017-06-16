defmodule Dashboard.Cache do
  use GenServer

  @table __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(@table, [:set, :protected, :named_table])

    {:ok, []}
  end

  def all() do
    :ets.foldl(fn({_, v}, acc) ->
      [v | acc]
    end, [], @table)
  end

  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, value}] ->
        {:ok, value}
      [] ->
        {:error, :not_found}
    end
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def handle_cast({:put, key, value}, state) do
    :ets.insert(@table, {key, value})

    {:noreply, state}
  end
end
