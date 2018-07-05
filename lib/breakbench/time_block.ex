defmodule Breakbench.TimeBlock do
  use Application

  import Supervisor.Spec

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    # Don't start charge
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def start_link do
    children = [
      worker(Breakbench.TimeBlock.Arrange, [])
    ]

    Supervisor.start_link(children, [
          name: __MODULE__,
      strategy: :one_for_one
    ])
  end


  ## Callbacks

  alias Breakbench.TimeBlock.{TimeSpan, ValidPeriod}

  import Breakbench.TimeBlock.ValidPeriod, only:
    [to_valid_from: 1, to_valid_through: 1]


  def build(day_of_week, start_at, end_at, valid_from, valid_through) do
    Map.new([
      day_of_week: day_of_week,
      start_at: start_at,
      end_at: end_at,
      valid_from: valid_from,
      valid_through: valid_through
    ])
  end


  ## Combination

  def merge(old_time_block, new_time_block) do
    try do
      time_blocks = [new_time_block, old_time_block]
      # Return, if both aren't mergeable
      unless mergeable?(old_time_block, old_time_block) do
        throw time_blocks
      end
      day_of_week = new_time_block.day_of_week

      {valid_from, valid_through} =
        ValidPeriod.merge(new_time_block, old_time_block)

      {start_at, end_at} =
        TimeSpan.merge(new_time_block, old_time_block)

      default = [build(day_of_week, start_at, end_at, valid_from, valid_through)]

      # Break exceed into small pieces
      Enum.reduce(time_blocks, default, fn time_block, accumulator ->
        condition1 = NaiveDateTime.compare(to_valid_from(valid_from),
          to_valid_from(time_block.valid_from)) == :gt
        condition2 = NaiveDateTime.compare(to_valid_through(valid_through),
          to_valid_through(time_block.valid_through)) == :lt

        accumulator
          |> append_on(condition1, build(day_of_week, time_block.start_at,
             time_block.end_at, time_block.valid_from, valid_from))
          |> append_on(condition2, build(day_of_week, time_block.start_at,
             time_block.end_at, valid_through, time_block.valid_through))
      end)
    catch
      hours -> hours
    end
  end

  @doc """
  Check weather both time blocks are mergeable
  """
  def mergeable?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if time spans overlap each other, include edges
      ts_condition1 = Time.compare(time_block0.start_at, time_block1.end_at) == :gt
      ts_condition2 = Time.compare(time_block0.end_at, time_block1.start_at) == :lt
      unless not(ts_condition1 or ts_condition2) do
        throw false
      end

      # Check if valid periods overlap each other, include edge
      vp_condition1 = NaiveDateTime.compare(to_valid_from(time_block0.valid_from),
        to_valid_through(time_block1.valid_through)) == :gt
      vp_condition2 = NaiveDateTime.compare(to_valid_through(time_block0.valid_through),
        to_valid_from(time_block1.valid_from)) == :lt
      unless not(vp_condition1 or vp_condition2) do
        throw false
      end

      # If one of the valid period edges overlap each other and both of the
      # time span edges aren't overlapping -> false
      ts_edge_1_overlap? = Time.compare(time_block0.start_at, time_block1.start_at) == :eq
      ts_edge_2_overlap? = Time.compare(time_block0.end_at, time_block1.end_at) == :eq
      vp_edge_1_overlap? = NaiveDateTime.compare(to_valid_from(time_block0.valid_from),
        to_valid_through(time_block1.valid_through)) == :eq
      vp_edge_2_overlap? = NaiveDateTime.compare(to_valid_through(time_block0.valid_through),
        to_valid_from(time_block1.valid_from)) == :eq
      if not(ts_edge_1_overlap? and ts_edge_2_overlap?) and
          (vp_edge_1_overlap? or vp_edge_2_overlap?) do
        throw false
      end

      # Else return true
      true
    catch
      boolean -> boolean
    end
  end


  ## Split

  def split(old_time_block, new_time_block) do
    try do
      # Return old_time_block, if nothing is splittable
      unless splittable?(old_time_block, new_time_block) do
        throw [old_time_block]
      end
      day_of_week = new_time_block.day_of_week

      {valid_from, valid_through} =
        ValidPeriod.split(new_time_block, old_time_block)

      condition1 = Time.compare(new_time_block.start_at, old_time_block.start_at) == :gt
      condition2 = Time.compare(new_time_block.end_at, old_time_block.end_at) == :lt
      condition3 = NaiveDateTime.compare(to_valid_from(new_time_block.valid_from),
        to_valid_from(old_time_block.valid_from)) == :gt
      condition4 = NaiveDateTime.compare(to_valid_through(new_time_block.valid_through),
        to_valid_through(old_time_block.valid_through)) == :lt

      []
        |> append_on(condition1, build(day_of_week, old_time_block.start_at,
           new_time_block.start_at, valid_from, valid_through))
        |> append_on(condition2, build(day_of_week, new_time_block.end_at,
           old_time_block.end_at, valid_from, valid_through))
        |> append_on(condition3, build(day_of_week, old_time_block.start_at,
           old_time_block.end_at, old_time_block.valid_from, new_time_block.valid_from))
        |> append_on(condition4, build(day_of_week, old_time_block.start_at,
           old_time_block.end_at, new_time_block.valid_through, old_time_block.valid_through))
    catch
      hours -> hours
    end
  end

  @doc """
  Check if both time blocks are splittable
  """
  def splittable?(time_block0, time_block1) do
    try do
      # Valid only if both time blocks are on the same day
      unless time_block0.day_of_week == time_block1.day_of_week do
        throw false
      end

      # Check if time spans overlap each other, exclude edges
      unless not(Time.compare(time_block0.start_at, time_block1.end_at) != :lt or
          Time.compare(time_block0.end_at, time_block1.start_at) != :gt) do
        throw false
      end

      # Check if valid periods overlap each other, include edge
      vp_condition1 = NaiveDateTime.compare(to_valid_from(time_block0.valid_from),
        to_valid_through(time_block1.valid_through)) != :lt
      vp_condition2 = NaiveDateTime.compare(to_valid_through(time_block0.valid_through),
        to_valid_from(time_block1.valid_from)) != :gt
      unless not(vp_condition1 or vp_condition2) do
        throw false
      end

      # Else, return true
      true
    catch
      boolean -> boolean
    end
  end


  ## Private

  defp append_on(list, condition, elements) do
    if condition, do: List.wrap(elements) ++ list, else: list
  end
end
