defmodule Breakbench.Timesheet.Arrange do
  use GenServer

  alias Breakbench.Timesheet.Glue
  alias Breakbench.Timesheet.TimeBlock


  @doc false
  def start_link, do: GenServer.start_link(__MODULE__, [])

  ## Callbacks

  @doc false
  def init(_) do
    # Create a public ets table
    :ets.new(__MODULE__, [:set, :public, :named_table])

    {:ok, []}
  end

  @doc false
  def terminate(_reason, _state), do: :ok


  ## State

  @doc """
  Get state info of a uid
  """
  def lookup_state(uid) do
    :ets.lookup(__MODULE__, uid)
  end
  def lookup_state(uid, :insert) do
    :ets.lookup_element(__MODULE__, uid, 2)
  end
  def lookup_state(uid, :delete) do
    :ets.lookup_element(__MODULE__, uid, 3)
  end

  @doc """
  Update state of a uid
  """
  def update_state(uid, :insert, data) do
    :ets.update_element(__MODULE__, uid, {2, data})
  end
  def update_state(uid, :delete, data) do
    :ets.update_element(__MODULE__, uid, {3, data})
  end

  @doc """
  Delete state of a uid
  """
  def delete_state(uid) do
    :ets.delete(__MODULE__, uid)
  end


  ## Functions

  @doc """
  Combine a new_time_block with a set of time_blocks.
  Then glue all the broken pieces together.

  -> state uid
  """
  def combine(time_blocks, new_time_block) do
    uid = new_state(time_blocks)

    time_blocks
      |> Enum.reduce([], & &2 ++ TimeBlock.combine(&1, new_time_block))
      |> Glue.paste(state: uid)

    # Returns state id
    uid
  end

  @doc """
  Break target_time_block from related set of time_blocks.
  The same as combine, then glue all the broken pieces together.

  -> state uid
  """
  def break(time_blocks, target_time_block) do
    uid = new_state(time_blocks)

    time_blocks
      |> Enum.reduce([], & &2 ++ TimeBlock.break(&1, target_time_block))
      |> Glue.paste(uid)

    # Returns state id
    uid
  end


  ## Private

  defp new_state(time_blocks) do
    # Create unique id for ets row
    uid = Ecto.UUID.generate()

    # spec -> uid, insert_time_blocks, delete_time_blocks
    :ets.insert(__MODULE__, {uid, [], time_blocks})

    # Returns uid
    uid
  end
end
