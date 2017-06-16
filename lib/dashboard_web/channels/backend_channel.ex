defmodule DashboardWeb.BackendChannel do
  use DashboardWeb, :channel

  def join("backend:sync", _, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
end
