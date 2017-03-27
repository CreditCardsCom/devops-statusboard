defmodule Dashboard.Worker do
  alias Dashboard.Cache
  alias Dashboard.Web.{BackendView, Endpoint}

  # TODO: Fix this, I feel like this is a shitty hack
  def start_link(backend) do
    Task.start_link(__MODULE__, :work, [backend])
  end

  def work(backend) do
    # TODO: Remove this block once backends have a standard error format
    data = case backend.load() do
      :error -> []
      {:error, _} -> []
      data -> data
    end

    Cache.put(backend, data)
    Endpoint.broadcast!(backend.name(), "sync",
                        BackendView.render("show.json", backend: data))

    Process.sleep(30_000)

    work(backend)
  end
end
