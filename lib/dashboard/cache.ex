defmodule Dashboard.Cache do
  @moduledoc """
  Manages the caching of data and pub/sub of any consumers that
  want to receive `{:cache_update, value}` messages.
  """

  use GenServer

  @table __MODULE__
  @pg_group {__MODULE__, :subscribers}

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :pg2.create(@pg_group)
    :ets.new(@table, [:set, :protected, :named_table])

    {:ok, []}
  end

  def all() do
    :ets.foldl(fn({_, v}, acc) ->
      [v | acc]
    end, [], @table)
    |> Enum.sort_by(&(&1.name))
  end

  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, value}] ->
        {:ok, value}
      [] ->
        {:error, :not_found}
    end
  end

  @doc """
  Puts a `key` and `value` combination into the cache process
  """
  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  @doc """
  Subscribes a `pid` for cache updates.
  """
  def subscribe(pid) do
    if subscribed?(pid) do
      :error
    else
      :pg2.join(@pg_group, pid)
    end
  end

  def unsubscribe(pid) do
    if subscribed?(pid) do
      :pg2.leave(@pg_group, pid)
    else
      :error
    end
  end

  defp subscribed?(pid) do
    pid in :pg2.get_members(@pg_group)
  end

  def handle_cast({:put, key, value}, state) do
    :ets.insert(@table, {key, value})
    send_cache_update(key, value)

    {:noreply, state}
  end

  defp send_cache_update(key, value) do
    @pg_group
    |> :pg2.get_members()
    |> Enum.each(fn(pid) ->
      send(pid, {:cache_update, key, value})
    end)
  end
end
