defmodule Dashboard.Worker do
  alias Dashboard.Cache
  alias Dashboard.Web.{BackendView, Endpoint}

  # TODO: Fix this, I feel like this is a shitty hack
  def start_link(backend) do
    Task.start_link(__MODULE__, :work, [backend])
  end

  def work(backend) do
    data = case backend.load() do
      {:ok, data} -> data
      {:error, _} -> nil
    end

    if data != nil do
      Cache.put(backend, data)
      Endpoint.broadcast!("backend:sync", backend.name(),
                          BackendView.render("show.json", backend: data))
    end

    Process.sleep(30_000)

    work(backend)
  end
end
