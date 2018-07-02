{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Breakbench.Repo, :manual)

Application.put_env(:wallaby, :base_url, BreakbenchWeb.Endpoint.url)
