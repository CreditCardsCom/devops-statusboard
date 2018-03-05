defmodule Dashboard do
  alias Dashboard.Cache

  defdelegate subscribe(pid), to: Cache
  defdelegate unsubscribe(pid), to: Cache
  defdelegate all(), to: Cache

  @doc """
  Refresh all checks, just kills the pingdom supervisor and lets it restart.
  """
  def refresh_checks() do
    case Process.whereis(Dashboard.Pingdom.Supervisor) do
      pid when is_pid(pid) ->
        Process.exit(pid, :kill)

        :ok
      _ ->
        :error
    end
  end
end
