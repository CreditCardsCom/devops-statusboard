defmodule Dashboard.Backend do
  @moduledoc """
  Defines a single remote backend that will be loaded as a worker process.
  """

  @callback load :: {:ok, [Map.t]} | {:error, String.t}

  defmacro __using__(opts) do
    quote do
      @behaviour Dashboard.Backend

      import Dashboard.Backend, only: [deepTake: 2]

      def name, do: unquote(opts)[:name]
      def interval, do: Keyword.get(unquote(opts), :interval, 30_000)
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

  @doc """
  Take the attribute from `map` for `key` returning a new map with only that key

  Returns `Map.t`
  """
  @spec deepTake(Map.t, [String.t]) :: Map.t
  def deepTake(_, []), do: %{}
  def deepTake(map, [key | rest]) do
    keys = String.split(key, ".")

    case get_in(map, keys) do
      nil -> %{}
      value -> %{} |> Map.put(List.last(keys), value)
    end
    |> Map.merge(deepTake(map, rest))
  end
end
