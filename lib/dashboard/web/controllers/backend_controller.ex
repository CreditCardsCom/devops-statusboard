defmodule Dashboard.Web.BackendController do
  use Dashboard.Web, :controller

  alias Dashboard.Backend
  alias Dashboard.Cache

  action_fallback Dashboard.Web.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", backends: Backend.configured)
  end

  def show(conn, %{"id" => name}) do
    case Backend.for(name) do
      backend when not is_nil(backend) ->
        render(conn, "show.json", backend: Cache.get(backend))
      _ -> {:error, :not_found}
    end
  end
end
