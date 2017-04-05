defmodule Dashboard.Web.Router do
  use Dashboard.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dashboard.Web do
    pipe_through :api

    options "/backends", BackendController, :options
    resources "/backends", BackendController, only: [:index, :show]
  end
end
