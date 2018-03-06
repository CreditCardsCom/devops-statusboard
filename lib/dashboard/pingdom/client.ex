defmodule Dashboard.Pingdom.Client do
  @moduledoc """
  Custom implementation of `HTTPoison.Base` for Pingdom api calls.
  """

  use HTTPoison.Base

  alias Dashboard.Pingdom.Config

  defp build_headers() do
    config = Config.get()
    auth = Base.encode64("#{config[:email]}:#{config[:password]}")

    [
      "Authorization": "Basic #{auth}",
      "App-Key": config[:app_key],
      "Account-Email": config[:account_email]
    ]
  end

  defp process_url(url) do
    "https://api.pingdom.com/api/2.1" <> url
  end

  defp process_request_headers(headers) do
    build_headers()
    |> Keyword.merge(headers)
  end

  defp process_response_body(body), do: Poison.decode!(body)
end
