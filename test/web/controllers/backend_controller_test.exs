defmodule Dashboard.Web.BackendControllerTest do
  use Dashboard.Web.ConnCase

  alias Dashboard.Backends
  alias Dashboard.Backends.Backend

  @create_attrs %{slug: "some slug"}
  @update_attrs %{slug: "some updated slug"}
  @invalid_attrs %{slug: nil}

  def fixture(:backend) do
    {:ok, backend} = Backends.create_backend(@create_attrs)
    backend
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, backend_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates backend and renders backend when data is valid", %{conn: conn} do
    conn = post conn, backend_path(conn, :create), backend: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, backend_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "slug" => "some slug"}
  end

  test "does not create backend and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, backend_path(conn, :create), backend: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen backend and renders backend when data is valid", %{conn: conn} do
    %Backend{id: id} = backend = fixture(:backend)
    conn = put conn, backend_path(conn, :update, backend), backend: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, backend_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "slug" => "some updated slug"}
  end

  test "does not update chosen backend and renders errors when data is invalid", %{conn: conn} do
    backend = fixture(:backend)
    conn = put conn, backend_path(conn, :update, backend), backend: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen backend", %{conn: conn} do
    backend = fixture(:backend)
    conn = delete conn, backend_path(conn, :delete, backend)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, backend_path(conn, :show, backend)
    end
  end
end
