defmodule Dashboard.Web.PageController do
  use Dashboard.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
