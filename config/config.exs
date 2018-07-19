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

config :breakbench, Breakbench.GoogleAPIs,
  endpoint: "https://maps.googleapis.com/",
  format: "json",
  language: "en",
  api_key: "AIzaSyAM3bebNwn1N3RhrE6vjNlTj-g-rRX0Gb8",
  httpoison: [recv_timeout: 5000, timeout: 8000]

config :breakbench, Stripe,
  endpoint: "https://api.stripe.com/",
  schema: "v1",
  version: "2018-05-21",
  list: [limit: 10],
  httpoison: [recv_timeout: 5000, timeout: 8000],
  webhook: [tolerance: 300000]

config :verk,
  queues: [default: 25, priority: 10],
  max_retry_count: 10,
  poll_interval: {:system, :integer, "VERK_POLL_INTERVAL", 5000},
  start_job_log_level: :info,
  done_job_log_level: :info,
  fail_job_log_level: :info,
  node_id: "1",
  redis_url: {:system, "VERK_REDIS_URL", "redis://127.0.0.1:6379"}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
