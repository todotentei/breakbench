defmodule Breakbench.Repo do
  use Ecto.Repo, otp_app: :breakbench

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  @doc """
  Fetch a boolean result from the schema
  """
  def has?(schema, clauses) do
    clauses = Map.new(clauses)
    # Default query
    default = "SELECT EXISTS(SELECT * FROM #{schema.__schema__(:source)}"

    raw_query =
      if map_size(clauses) > 0 do
        default = default <> " WHERE "
        # Build where clause function helper
        build = fn {{k, _}, i}, acc ->
          acc = acc <> "#{k} = $#{i}"
          if i < map_size(clauses), do: acc <> " AND ", else: acc <> ")"
        end
        # Construct where conditions
        clauses
          |> Enum.with_index(1)
          |> Enum.reduce(default, build)
      else
        default
      end

    case query!(raw_query, Map.values(clauses)) do
      %Postgrex.Result{num_rows: 1, rows: [[boolean]]} -> boolean
      _ -> :error
    end
  end
end
