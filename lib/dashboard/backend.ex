defmodule Dashboard.Backend do
  @moduledoc """
  Defines a single remote backend that will be loaded as a worker process.
  """

  @callback load() :: {:ok, [Map.t]} | {:error, String.t}

  defmacro __using__(opts) do
    quote do
      @behaviour Dashboard.Backend

      def name, do: unquote(opts)[:name]
    end
  end

  @doc """
  Returns the backend modules that have been configured in the application.

  Returns `[module(), module()]`
  """
  @spec configured() :: [module()]
  def configured do
    Application.get_env(:dashboard, :backends, [])
  end

  @doc """
  Find the appropriate backend module for the supplied `name`

  Returns `module()`
  """
  @spec for(String.t) :: module()
  def for(name) do
    Enum.find(configured(), &(&1.name == name))
  end
end
