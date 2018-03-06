defmodule Dashboard.Metrics.Point do
  @moduledoc """
  Represents a metric for a single point in time
  """

  alias Dashboard.Metrics.Point

  # Seconds per period
  @supported [:hour, :half, :quarter]
  @periods [hour: 60 * 60, half: 60 * 30, quarter: 60 * 15]

  @enforce_keys [:time, :value]
  defstruct [:time, :value]

  @doc """
  Create a new %Point{} from the given keywork arguments.

    iex> Dashboard.Metrics.Point.new(time: 1, value: 1) |> IO.inspect()
    %Dashboard.Metrics.Point{time: 1, value: 1}
  """
  def new(attrs \\ []), do: struct(__MODULE__, attrs)

  @doc """
  """
  def interpolate(points, _period \\ :hour)
  def interpolate([], _period), do: []
  def interpolate(points, _period) when length(points) < 2, do: points
  def interpolate(points, period) when is_list(points) and period in @supported do
    points
    |> Enum.sort_by(&(&1.time))
    |> do_interpolate(@periods[period])
    |> List.flatten()
  end

  # Actually interpolate the values, creating intervals in the given period when
  # values are missing. When we only have one point, we are at the end of the series.
  defp do_interpolate(points, _period) when length(points) == 1, do: points
  defp do_interpolate([current | [next | _] = remaining], period) do
    slope = calculate_slope(current, next)
    chunks =
      intervals_between(current.time, next.time, period)
      |> Enum.reduce([current], fn(time, [lastPoint | _] = acc) ->
        [next_point(slope, time, lastPoint) | acc]
      end)
      |> Enum.reverse()

    [chunks | do_interpolate(remaining, period)]
  end

  # Calculate the next point given a slope, time, and the next point in the
  # series.
  defp next_point(slope, time, %Point{} = last) do
    %Point{
      time: time,
      value: round(slope * (time - last.time) + last.value)
    }
  end

  @doc """
  Generate a list of time chunks begining at `start` through `stop`,
  time values are exclusive, starting from the next time point following
  `start`.

    iex> Dashboard.Metrics.Point.intervals_between(1519923600, 1519927200, 60 * 60)
    []

    iex> Dashboard.Metrics.Point.intervals_between(1519923600, 1519930800, 60 * 60)
    [1519927200]
  """
  def intervals_between(start, stop, period) when start + period < stop do
    intervals = div((stop - start), period)

    for t <- 1..(intervals - 1) do
      start + (period * t)
    end
  end
  def intervals_between(_beginning, _ending, _period), do: []

  # Calulate the slope from a point to the next point.
  defp calculate_slope(from = %Point{}, to = %Point{}) do
    (to.value - from.value) / (to.time - from.time)
  end
end
