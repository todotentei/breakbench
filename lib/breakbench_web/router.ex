defmodule BreakbenchWeb.Router do
  use BreakbenchWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :remember_me
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :ensure_authenticated
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser]

    get "/login", SessionController, :new
    get "/register", UserController, :new

    post "/login", SessionController, :create
    post "/register", UserController, :create

    delete "/logout", SessionController, :delete
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
  end

  scope "/api", BreakbenchWeb do
    pipe_through [:api]
  end

  scope "/graphql" do
    pipe_through [:api]

    forward "/", Absinthe.Plug.GraphiQL,
      schema: BreakbenchWeb.Schema,
      interface: :simple,
      context: %{pubsub: BreakbenchWeb.Endpoint}
  end
end
