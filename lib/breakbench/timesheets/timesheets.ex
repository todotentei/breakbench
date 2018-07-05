defmodule Breakbench.Timesheets do
  @moduledoc """
  The Timesheets context.
  """

  import Ecto.Query, warn: false
  alias Breakbench.Repo

  alias Breakbench.Timesheets.TimeBlock


  def list_time_blocks do
    Repo.all(TimeBlock)
  end

  def get_time_block!(id), do: Repo.get!(TimeBlock, id)

  def create_time_block(attrs \\ %{}) do
    %TimeBlock{}
      |> TimeBlock.changeset(attrs)
      |> Repo.insert()
  end

  def update_time_block(%TimeBlock{} = time_block, attrs) do
    time_block
      |> TimeBlock.changeset(attrs)
      |> Repo.update()
  end

  def delete_time_block(%TimeBlock{} = time_block) do
    Repo.delete(time_block)
  end

  def change_time_block(%TimeBlock{} = time_block) do
    TimeBlock.changeset(time_block, %{})
  end
end
