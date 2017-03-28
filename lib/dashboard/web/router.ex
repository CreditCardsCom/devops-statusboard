defmodule Dashboard.Web.Router do
  use Dashboard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dashboard.Web do
    pipe_through :browser # Use the default browser stack
  end

  # Other scopes may use custom stacks.
  scope "/api", Dashboard.Web do
    pipe_through :api

    options "/backends", BackendController, :options
    resources "/backends", BackendController, only: [:index, :show]
  end
end
