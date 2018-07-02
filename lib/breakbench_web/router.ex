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

  pipeline :ensure_auth do
    plug Breakbench.EnsureAuthenticated
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", UserController, :new
    post "/register", UserController, :create
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser, :ensure_auth]
  end

  scope "/api" do
    pipe_through [:api]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BreakbenchWeb.Schema,
      interface: :simple,
      context: %{pubsub: BreakbenchWeb.Endpoint}
  end
end
