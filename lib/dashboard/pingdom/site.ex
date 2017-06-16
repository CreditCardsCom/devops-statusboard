defmodule Dashboard.Pingdom.Site do
  alias Dashboard.Pingdom.Client

  @enforce_keys [:id, :name, :hostname]
  defstruct [:id, :name, :hostname, :metrics, :outages]

  def new(attrs \\ []) do
    struct(__MODULE__, attrs)
  end

  def fetch_sites() do
    %{body: body, status_code: 200} = Client.get!("/checks")

    body
    |> Map.fetch!("checks")
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
