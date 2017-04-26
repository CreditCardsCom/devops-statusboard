defmodule Dashboard.Backend.StatusPage do
  use Dashboard.Backend, name: "status_page"

  @mappedKeys ~w(name description status)

  defp headers do
    token =
      Application.fetch_env!(:dashboard, __MODULE__)
      |> Keyword.get(:token)

    Keyword.new
    |> Keyword.put(:"Authorization", "OAuth #{token}")
  end

  def load do
    with {:ok, resp} <- HTTPoison.get(build_url(), headers(), ssl: [{:versions, [:'tlsv1.2']}]),
         {:ok, body} <- Map.fetch(resp, :body),
         {:ok, components} <- Poison.decode(body)
    do
      data = components
             |> Enum.reject(fn(%{"group_id" => id}) -> id == nil end)
             |> Enum.map(&map(&1))
             |> Enum.sort(&compare/2)

      {:ok, data}
    end
  end

  defp build_url, do: "https://api.statuspage.io/v1/pages/b9nfj74m4nvc/components.json"

  defp map(map) do
    deepTake(map, @mappedKeys)
  end

  @spec compare(map(), map()) :: boolean()
  defp compare(a = %{"status" => status}, b = %{"status" => status}),
    do: a["updated_at"] > b["updated_at"]
  defp compare(%{"status" => "major_outage"}, %{"status" => _}), do: true
  defp compare(%{"status" => "partial_outage"}, %{"status" => "major_outage"}), do: false
  defp compare(%{"status" => "partial_outage"}, %{"status" => _}), do: true
  defp compare(%{"status" => "degraded_performance"}, %{"status" => "operational"}), do: true
  defp compare(%{"status" => "degraded_performance"}, %{"status" => _}), do: false
  defp compare(%{"status" => "operational"}, %{"status" => _}), do: false
end
