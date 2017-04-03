defmodule Dashboard.Web.BackendControllerTest do
  use Dashboard.Web.ConnCase

  alias Dashboard.Backend

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, backend_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end
end
