defmodule Dashboard.Backend do
  @callback load() :: [Map.t]

  defmacro __using__(opts) do
    quote do
      @behaviour Dashboard.Backend

      def name, do: unquote(opts)[:name]
    end
  end

  def configured do
    Application.get_env(:dashboard, :backends, [])
  end

  def for(name) do
    Enum.find(configured(), &(&1.name == name))
  end
end
