defmodule BreakbenchWeb.Router do
  use BreakbenchWeb, :router


  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate, user_context: Breakbench.Auth
    plug Phauxth.Remember
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BreakbenchWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/register", UserController, :new

    post "/login", SessionController, :create
    post "/register", UserController, :create

    delete "/logout", SessionController, :delete
  end

  scope "/api" do
    pipe_through [:api]

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: BreakbenchWeb.Schema,
      interface: :simple,
      context: %{pubsub: BreakbenchWeb.Endpoint}
  end
end
