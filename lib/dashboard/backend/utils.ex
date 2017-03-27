defmodule Dashboard.Backend.Utils do
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
