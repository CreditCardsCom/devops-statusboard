defmodule Dashboard.Web.BackendView do
  use Dashboard.Web, :view

  alias Dashboard.Web.{BackendView, Endpoint, Router}

  def render("index.json", %{backends: backends}) do
    %{data: render_many(backends, BackendView, "backends.json")}
  end

  def render("show.json", %{backend: nil}), do: %{data: []}
  def render("show.json", %{backend: backend}) do
    %{data: render_one(backend, BackendView, "backend.json")}
  end

  def render("backend.json", %{backend: backend}), do: backend

  def render("backends.json", %{backend: module}) do
    name =
      Atom.to_string(module)
      |> String.split(".")
      |> List.last

    %{
      name: name,
      href: Router.Helpers.backend_path(Endpoint, :show, module.name())
    }
  end
end
