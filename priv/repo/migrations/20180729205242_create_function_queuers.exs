defmodule Breakbench.Repo.Migrations.CreateFunctionQueuers do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION queuers(
        _space_id CHARACTER VARYING(255),
        _game_mode_id UUID
      ) RETURNS TABLE (
        matchmaking_queue_id UUID
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          mmq.id
        FROM matchmaking_queues AS mmq
        RIGHT OUTER JOIN spaces AS spc ON
          ST_DWithin(mmq.geom::geography, spc.geom::geography, mmq.radius)
        INNER JOIN fields AS fld ON
          spc.id = fld.space_id
        INNER JOIN field_game_modes AS fgm ON
          fld.id = fgm.field_id
        RIGHT OUTER JOIN matchmaking_space_distance_matrices AS msd ON
          spc.id = msd.space_id AND
          mmq.id = msd.matchmaking_queue_id
        WHERE
          spc.id = _space_id AND
          fgm.game_mode_id = _game_mode_id
        ORDER BY
          mmq.inserted_at,
          msd.duration;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION queuers ( character varying, uuid )"
  end
end
