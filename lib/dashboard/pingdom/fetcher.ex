defmodule Dashboard.Pingdom.Fetcher do
  @moduledoc """
  Genserver that represents an individual check in Pingdom, responsible for
  updating cached data with the populated metrics.
  """

  use GenServer

  alias Dashboard.Cache
  alias Dashboard.Pingdom.Client
  alias Dashboard.Metrics.Point

  @interval 30_000
  @period (60 * 60 * 24) # 24 Hours

  def child_spec(check) do
    super(check)
    |> Map.put(:id, :"#{__MODULE__}.#{check.id}")
  end

  def start_link(check) do
    GenServer.start_link(__MODULE__, check)
  end

  def init(check) do
    Process.send(self(), :fetch, [])

    {:ok, check}
  end

  def handle_info(:fetch, %{id: id} = state) do
    metrics = Task.async(__MODULE__, :fetch_metrics, [id])
    outages = Task.async(__MODULE__, :fetch_outages, [id])

    %{state |
      metrics: Task.await(metrics),
      outages: Task.await(outages)}
    |> put_cache()

    Process.send_after(self(), :fetch, @interval)

    {:noreply, state}
  end

  defp put_cache(state), do: Cache.put(state.id, state)

  def fetch_metrics(id) do
    from = System.system_time(:seconds) - @period
    %{body: body, status_code: 200} = Client.get!("/summary.performance/#{id}?from=#{from}")

    body
    |> get_in(["summary", "hours"])
    |> Enum.map(fn(%{"avgresponse" => value, "starttime" => time}) ->
      Point.new(time: time, value: value)
    end)
    |> Point.interpolate(:hour)
  end

  @doc """
  {
  "summary" : {
    "states" : [ {
      "status" : "up",
      "timefrom" : 1293143523,
      "timeto" : 1294180263
      }
      ]
    }
  }
  """
  def fetch_outages(id) do
    %{body: body, status_code: 200} = Client.get!("/summary.outage/#{id}")

    get_in(body, ["summary", "states"]) || []
  end
end
