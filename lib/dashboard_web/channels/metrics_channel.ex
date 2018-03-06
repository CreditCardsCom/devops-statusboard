defmodule DashboardWeb.MetricsChannel do
  use DashboardWeb, :channel

  def join("metrics:updates", _, socket) do
    send(self(), :on_join)

    {:ok, socket}
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

  def handle_info(:on_join, socket) do
    Dashboard.subscribe(self())

    push(socket, "all", %{checks: Dashboard.all()})

    {:noreply, socket}
  end
end
