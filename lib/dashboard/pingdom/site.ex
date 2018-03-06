defmodule Dashboard.Pingdom.Site do
  alias Dashboard.Pingdom.Client

  @enforce_keys [:id, :name, :hostname]
  defstruct [:id, :name, :hostname, :metrics, :outages]

  @type t :: %__MODULE__{
          id: integer(),
          name: binary(),
          hostname: binary(),
          metrics: Dashboard.Metrics.Point.t,
          outages: list()
        }

  @spec new(keyword()) :: t
  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  @doc """
  Returns all checks from the Pingdom API.
  """
  @spec fetch_sites() :: [t]
  def fetch_sites() do
    %{body: body, status_code: 200} = Client.get!("/checks")

    body
    |> Map.fetch!("checks")
    |> Enum.filter(fn(%{"type" => type, "status" => status}) ->
      type == "http" && status != "paused"
    end)
    |> Enum.map(fn(map) ->
      map
      |> Map.take(~w(id name hostname))
      |> Enum.into([], fn({k, v}) ->
        {String.to_atom(k), v}
      end)
      |> new()
    end)
  end
end
