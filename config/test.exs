use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :breakbench, BreakbenchWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :breakbench, Breakbench.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "breakbench_v1_3_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure stripe
config :breakbench, Stripe,
  test_mode: true,
  mock_server: Breakbench.StripeMockServer
