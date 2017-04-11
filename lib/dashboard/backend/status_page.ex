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
      components
      |> Enum.sort_by(&(&1["updated_at"]))
      |> Enum.reverse
      |> Enum.take(10)
      |> Enum.map(&map(&1))
    end
  end

  defp build_url, do: "https://api.statuspage.io/v1/pages/b9nfj74m4nvc/components.json"

  defp map(map) do
    deepTake(map, @mappedKeys)
  end
end
