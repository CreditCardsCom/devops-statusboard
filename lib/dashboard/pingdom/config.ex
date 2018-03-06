defmodule Dashboard.Pingdom.Config do
  @moduledoc """
  Module for collecting Pingdom configuration keys
  """

  @configuration_keys ~w(app_key email password account_email)a

  @doc """
  Get all `@configuration_keys` from `Application.get_env`
  """
  def get() do
    env = Application.fetch_env!(:dashboard, :pingdom)

    for k <- @configuration_keys, into: [] do
      {k, Keyword.fetch!(env, k)}
    end
  end
end
