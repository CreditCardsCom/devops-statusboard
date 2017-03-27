defmodule Dashboard.BackendsTest do
  use Dashboard.DataCase

  alias Dashboard.Backends
  alias Dashboard.Backends.Backend

  @create_attrs %{slug: "some slug"}
  @update_attrs %{slug: "some updated slug"}
  @invalid_attrs %{slug: nil}

  def fixture(:backend, attrs \\ @create_attrs) do
    {:ok, backend} = Backends.create_backend(attrs)
    backend
  end

  test "list_backends/1 returns all backends" do
    backend = fixture(:backend)
    assert Backends.list_backends() == [backend]
  end

  test "get_backend! returns the backend with given id" do
    backend = fixture(:backend)
    assert Backends.get_backend!(backend.id) == backend
  end

  test "create_backend/1 with valid data creates a backend" do
    assert {:ok, %Backend{} = backend} = Backends.create_backend(@create_attrs)
    assert backend.slug == "some slug"
  end

  test "create_backend/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Backends.create_backend(@invalid_attrs)
  end

  test "update_backend/2 with valid data updates the backend" do
    backend = fixture(:backend)
    assert {:ok, backend} = Backends.update_backend(backend, @update_attrs)
    assert %Backend{} = backend
    assert backend.slug == "some updated slug"
  end

  test "update_backend/2 with invalid data returns error changeset" do
    backend = fixture(:backend)
    assert {:error, %Ecto.Changeset{}} = Backends.update_backend(backend, @invalid_attrs)
    assert backend == Backends.get_backend!(backend.id)
  end

  test "delete_backend/1 deletes the backend" do
    backend = fixture(:backend)
    assert {:ok, %Backend{}} = Backends.delete_backend(backend)
    assert_raise Ecto.NoResultsError, fn -> Backends.get_backend!(backend.id) end
  end

  test "change_backend/1 returns a backend changeset" do
    backend = fixture(:backend)
    assert %Ecto.Changeset{} = Backends.change_backend(backend)
  end
end
