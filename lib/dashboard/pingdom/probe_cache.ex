defmodule Dashboard.Pingdom.ProbeCache do
  use GenServer

  alias Dashboard.Pingdom.Client

  @country_iso "US"
  @interval 60_000 * 30 # 30 minutes in milliseconds

  def get_probe_ids() do
    GenServer.call(__MODULE__, :get)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Initialize the probe cache `GenServer` instance, instantly attempting to
  retrieve all probe ids.
  """
  def init(_) do
    send(self(), :fetch)

    {:ok, []}
  end

  @doc """
  Fetch probe ids from the cache
  """
  def handle_info(:fetch, _ids) do
    %{body: body, status_code: 200} = Client.get!("/probes?onlyactive=true")
    ids =
      body
      |> Map.get("probes")
      |> Enum.filter(&(&1["countryiso"] == @country_iso))
      |> Enum.map(&(&1["id"]))

    Process.send_after(self(), :fetch, @interval)

    {:noreply, ids}
  end

  @doc """
  Return all the ids from the cache
  """
  def handle_call(:get, _from, ids), do: {:reply, ids, ids}
end
