defmodule Dashboard.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children = [
      DashboardWeb.Endpoint,
      Dashboard.Cache,
      Dashboard.Pingdom.Supervisor
    ]

    configure(:pingdom)

    opts = [strategy: :one_for_one, name: Dashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp configure(:pingdom) do
    env_values = env(:pingdom, [:app_key, :email, :password, :account_email])
    values =
      Application.get_env(:dashboard, :pingdom, [])
      |> Keyword.merge(env_values)

    Application.put_env(:dashboard, :pingdom, values)
  end

  defp env(key, config_keys) do
    upperized_key = upcase(key)

    Enum.reduce(config_keys, [], fn(k, acc) ->
      case System.get_env("#{upperized_key}_#{upcase(k)}") do
        nil -> acc
        value -> Keyword.put(acc, k, value)
      end
    end)
  end

  defp upcase(key), do: to_string(key) |> String.upcase()
end
