defmodule Breakbench.Repo do
  use Ecto.Repo, otp_app: :breakbench

  import Ecto.Query
  alias Breakbench.PostgrexHelper


  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def query_all(sql, attrs) do
    with {:ok, %Postgrex.Result{} = result} <- query(sql, attrs) do
      PostgrexHelper.result_to_map(result)
    else
      _ -> raise Protocol.UndefinedError
    end
  end

  def query_one(sql, attrs) do
    case query_all(sql, attrs) do
      [head | []] -> head
      []          -> nil
      results     -> raise Ecto.MultipleResultsError,
                           queryable: sql,
                           count: length(results)
    end
  end

  def has?(schema, clauses) do
    case all(from(schema, where: ^Enum.to_list(clauses))) do
      [_head | _] -> true
      [] -> false
    end
  end
end
