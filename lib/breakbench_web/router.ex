defmodule BreakbenchWeb.Router do
  use BreakbenchWeb, :router

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

  pipeline :auth do
    plug Breakbench.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser, :auth, :ensure_auth]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BreakbenchWeb do
  #   pipe_through :api
  # end
end
