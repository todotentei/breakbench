defmodule Breakbench.PostgrexFuncs do
  @moduledoc false

  defmacro fn_next_available(space_id, game_mode_id, searchrange) do
    quote do
      fragment "next_available(?,?,?)",
        unquote(space_id),
        type(unquote(game_mode_id), :binary_id),
        unquote(searchrange)
    end
  end

  defmacro fn_overlap_time_blocks(day_of_week, start_time, end_time, from_date, through_date) do
    quote do
      fragment "overlap_time_blocks(?,?,?,?,?)",
        unquote(day_of_week),
        unquote(start_time),
        unquote(end_time),
        unquote(from_date),
        unquote(through_date)
    end
  end

  defmacro fn_populated_spaces(geom, radius) do
    quote do
      fragment "populated_spaces(?,?)",
        unquote(geom),
        unquote(radius)
    end
  end

  defmacro fn_queuers(space_id, game_mode_id) do
    quote do
      fragment "queuers(?,?)",
        unquote(space_id),
        type(unquote(game_mode_id), :binary_id)
    end
  end

  defmacro fn_space_within(geom, radius, game_mode_ids) do
    quote do
      fragment "space_within(?,?,?)",
        unquote(geom),
        unquote(radius),
        type(unquote(game_mode_ids), {:array, :binary_id})
    end
  end

  defmacro fn_total_game_price(game_area_id, kickoff, duration) do
    quote do
      fragment "total_game_price(?,?,?)",
        unquote(game_area_id),
        unquote(kickoff),
        unquote(duration)
    end
  end
end
