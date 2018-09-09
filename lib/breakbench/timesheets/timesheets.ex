defmodule Breakbench.Timesheets do
  @moduledoc """
  The Timesheets context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Timesheets.TimeBlock

  @doc """
  Get a time block.
  """
  @spec get_time_block!(term :: binary()) :: TimeBlock.t()
  def get_time_block!(id) do
    Repo.get!(TimeBlock, id)
  end

  @doc """
  Creates a time block.
  """
  @spec create_time_block(
    attrs :: map()
  ) :: {:ok, TimeBlock.t()} | {:error, Ecto.Changeset.t()}
  def create_time_block(attrs \\ %{}) do
    %TimeBlock{}
    |> TimeBlock.changeset(attrs)
    |> Repo.insert()
  end
end
