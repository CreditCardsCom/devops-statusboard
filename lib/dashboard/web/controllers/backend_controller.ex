defmodule Dashboard.Web.BackendController do
  use Dashboard.Web, :controller

  alias Dashboard.Backend
  alias Dashboard.Cache

  action_fallback Dashboard.Web.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", backends: Backend.configured)
  end

  def show(conn, %{"id" => name, "limit" => limit}) do
    limit = String.to_integer(limit)

    case Backend.for(name) do
      nil -> {:error, :not_found}
      backend ->
        data = Cache.get(backend) |> Enum.take(limit)

        render(conn, "show.json", backend: data)
    end
  end

  def show(conn, %{"id" => name}) do
    case Backend.for(name) do
      nil -> {:error, :not_found}
      backend -> render(conn, "show.json", backend: Cache.get(backend))
    end
  end
end
