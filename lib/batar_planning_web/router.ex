defmodule BatarPlanningWeb.Router do
  use BatarPlanningWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
  end

  scope "/", BatarPlanningWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", BatarPlanningWeb do
    pipe_through :api
    resources "/users", UserController, except: [:new, :edit]
  end
end
