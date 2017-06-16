defmodule Dashboard.Pingdom.Config do
  @configuration_keys ~w(app_key email password account_email)a

  def get() do
    env = Application.fetch_env!(:dashboard, :pingdom)

    for k <- @configuration_keys, into: [] do
      {k, Keyword.fetch!(env, k)}
    end
  end
end
