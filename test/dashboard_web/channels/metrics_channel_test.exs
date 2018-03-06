defmodule DashboardWeb.MetricsChannelTest do
  use DashboardWeb.ChannelCase

  alias DashboardWeb.MetricsChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(MetricsChannel, "backend:sync")

    {:ok, socket: socket}
  end
end
