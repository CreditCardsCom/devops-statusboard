defmodule Dashboard.Backend.TravisCI do
  use Dashboard.Backend, name: "travis"

  @travisUrl "https://api.travis-ci.com"
  @travisParams %{
    "repository.active" => "true",
    "sort_by" => "current_build:desc",
    "limit" => "15",
    "include" => "repository.current_build,build.commit"
  }

  @mappedKeys ~w(name slug current_build)

  defp headers do
    Keyword.new
    |> Keyword.put(:"Authorization", "token #{get_token()}")
    |> Keyword.put(:"Travis-API-Version", "3")
    |> Keyword.put(:"Content-Type", "application/json")
  end

  def load do
    with {:ok, resp} <- HTTPoison.get(build_url(), headers()),
         {:ok, body} <- Map.fetch(resp, :body),
         {:ok, response} <- Poison.decode(body),
         {:ok, repos} <- Map.fetch(response, "repositories")
    do
      repos
      |> Enum.map(&map(&1))
    else
      {:error, error} -> {:error, error}
      :error -> {:error, "unknown error"}
    end
  end

  defp token_url, do: "#{@travisUrl}/auth/github"
  defp build_url, do: "#{@travisUrl}/repos?" <> URI.encode_query(@travisParams)

  defp get_token do
    case :ets.lookup(__MODULE__, "token") do
      [{"token", token}] -> token
      [] ->
        # TODO: This could be simplified to calling get_token() a second time
        case create_token() do
          {:ok, token} -> token
          _ -> ""
        end
    end
  end

  defp create_token do
    config = Application.fetch_env!(:dashboard, __MODULE__)
    body = %{"github_token" => Keyword.get(config, :github_token, "")}
    headers = ['Content-Type': "application/json"]

    with {:ok, body} <- Poison.encode(body),
         {:ok, resp} <- HTTPoison.post(token_url(), body, headers),
         {:ok, body} <- Map.fetch(resp, :body),
         {:ok, response} <- Poison.decode(body),
         {:ok, token} <- Map.fetch(response, "access_token")
     do
      :ets.insert(__MODULE__, {"token", token})

      {:ok, token}
    end
  end

  # Map out the repo into the standard datastructure
  defp map(repo) do
    deepTake(repo, @mappedKeys)
  end
end
