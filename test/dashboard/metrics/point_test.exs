defmodule Dashboard.Metrics.PointTest do
  use ExUnit.Case

  doctest Dashboard.Metrics.Point

  alias Dashboard.Metrics.Point

  test "#interpolate(points, :hour)" do
    points =
      [
        %Point{time: 1519905600, value: 60},
        %Point{time: 1519920000, value: 120}
      ]
      |> Point.interpolate(:hour)

    assert length(points) == 5
    assert Enum.at(points, 0).value == 60
    assert Enum.at(points, 1).value == 75
    assert Enum.at(points, 2).value == 90
    assert Enum.at(points, 3).value == 105
    assert Enum.at(points, 4).value == 120
  end

  test "#intervals_between(start, stop, 60 * 60)" do
    slices = Point.intervals_between(1519905600, 1519927200, 60 * 60)
    assert length(slices) == 5
    assert hd(slices) == 1519909200
    assert List.last(slices) == 1519923600

    slices = Point.intervals_between(1519905600, 1519927260, 60 * 60)
    assert length(slices) == 5
    assert hd(slices) == 1519909200
    assert List.last(slices) == 1519923600
  end
end
