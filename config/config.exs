# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :breakbench,
  ecto_repos: [Breakbench.Repo]

# Configures the endpoint
config :breakbench, BreakbenchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vA0w+HESWGen4ZcRryzXOs+iVcMRfrmD5wLeoAsj4vHssZUPdCGjKIysURBPu3oB",
  render_errors: [view: BreakbenchWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Breakbench.PubSub, adapter: Phoenix.PubSub.PG2]

config :breakbench, Breakbench.Repo,
  types: Breakbench.PostgresTypes

config :breakbench, Google,
  endpoint: "https://maps.googleapis.com/maps/api/",
  format: "json", # json only
  language: "en",
  geocode_api_key: "AIzaSyDYIn59MUqqM4kk8Gj05vd6HaORE1TuKu8",
  timezone_api_key: "AIzaSyA3yOIC-s_zBag_2RwIc4QFDtTaYV1rVpI",
  httpoison: [recv_timeout: 5000, timeout: 8000]

config :breakbench, Stripe,
  endpoint: "https://api.stripe.com/",
  schema: "v1",
  version: "2018-05-21",
  list: [limit: 10],
  httpoison: [recv_timeout: 5000, timeout: 8000],
  webhook: [tolerance: 300000]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
