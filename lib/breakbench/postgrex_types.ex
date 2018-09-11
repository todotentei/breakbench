postgrex_extensions = Ecto.Adapters.Postgres.extensions()
external_extensions = [
  Geo.PostGIS.Extension
]

Postgrex.Types.define Breakbench.PostgresTypes,
  external_extensions ++ postgrex_extensions,
  json: Poison
