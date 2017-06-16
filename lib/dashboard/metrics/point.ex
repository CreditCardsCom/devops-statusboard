defmodule Dashboard.Metrics.Point do
  @moduledoc """
  Represents a metric for a single point in time
  """

  alias Dashboard.Metrics.Point

  @hour (60 * 60)

  @enforce_keys [:time, :value]
  defstruct [:time, :value]

  def new(attrs \\ []), do: struct(__MODULE__, attrs)

  def interpolate(points, _granularity \\ :hour)
  def interpolate([], _granularity), do: []
  def interpolate(points, granularity) do
    points
    |> Enum.sort_by(&(&1.time))
    |> do_interpolate(granularity)
  end

  defp do_interpolate([first | points], granularity) when is_list(points) do
    Enum.flat_map_reduce(points, first, fn(point, last) ->
      slope = calculate_slope(last, point) |> IO.inspect()
      chunks =
        generate_chunks(last.time, point.time, granularity)
        |> Enum.map(fn(time) ->
          Point.new(time: time, value: slope * time)
        end)
        |> Enum.sort_by(&(&1.time))
        |> IO.inspect()

        {chunks, point}
    end)
    |> IO.inspect()
    |> elem(0)
  end

  @doc """
  Generate a list of time chunks begining at `from` until `to`

    iex> generate_chunks(1519923600, 1519927200, :hour)
    [1519923600, 1519927200]

    iex> generate_chunks(1519923600, 1519927230, :hour)
    [1519923600, 1519927200]
  """
  def generate_chunks(from, to, :hour) when from < to do
    [from | generate_chunks(from + @hour, to, :hour)]
  end
  def generate_chunks(_from, _to, :hour), do: []

  defp calculate_slope(from = %Point{}, to = %Point{}) do
    (to.value - from.value) / (to.time - from.time)
  end
end
