defmodule DashboardWeb.MetricsChannel do
  use DashboardWeb, :channel

  def join("metrics:updates", _, socket) do
    push(socket, "all", Dashboard.all())

    {:ok, socket} |> IO.inspect()
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_info({:cache_update, _key, value}, socket) do
    push(socket, "update", value)

    {:noreply, socket}
  end
end
