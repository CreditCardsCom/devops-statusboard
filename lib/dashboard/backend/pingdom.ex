defmodule Dashboard.Backend.Pingdom do
  use Dashboard.Backend, name: "pingdom"

  @mappedKeys ~w(name hostname status tags
                 lastresponsetime type.http.url type.http.port)

  alias Dashboard.Backend.Utils

  defp headers do
    config = Application.fetch_env!(:dashboard, __MODULE__)
    email = Keyword.get(config, :email, "")
    password = Keyword.get(config, :password, "")
    auth = Base.encode64("#{email}:#{password}")

    Keyword.new
    |> Keyword.put(:"Authorization", "Basic #{auth}")
    |> Keyword.put(:"App-Key", Keyword.get(config, :app_key, ""))
    |> Keyword.put(:"Account-Email", Keyword.get(config, :account_email, ""))
  end

  def load do
    with {:ok, resp} <- HTTPoison.get(build_url(), headers()),
         {:ok, body} <- Map.fetch(resp, :body),
         {:ok, response} <- Poison.decode(body),
         {:ok, checks} <- Map.fetch(response, "checks")
    do
      checks
      |> Enum.map(&Map.fetch!(&1, "id"))
      |> Task.async_stream(__MODULE__, :load, [])
      |> Enum.map(fn({:ok, result}) ->
        case result do
          {:error, _} -> nil
          value -> map(value)
        end
      end)
      |> Enum.filter(&(&1 !== nil))
    else
      :error -> {:error, "unknown error"}
      {:error, message} -> {:error, message}
    end
  end

  def load(id) do
    with {:ok, resp} <- HTTPoison.get(build_url(id), headers()),
         {:ok, body} <- Map.fetch(resp, :body),
         {:ok, response} <- Poison.decode(body),
         {:ok, check} <- Map.fetch(response, "check")
    do
      check
    else
      :error -> {:error, "unknown error"}
      {:error, error = %HTTPoison.Error{}} -> {:error, HTTPoison.Error.message(error)}
      {:error, message} -> {:error, message}
    end
  end

  defp build_url, do: "https://api.pingdom.com/api/2.0/checks"
  defp build_url(id), do: "https://api.pingdom.com/api/2.0/checks/#{id}"

  # Map out the check into the standard datastructure
  defp map(check) do
    Utils.deepTake(check, @mappedKeys)
    |> Map.update!("tags", &Enum.map(&1, fn(tag) -> tag["name"] end))
  end
end
