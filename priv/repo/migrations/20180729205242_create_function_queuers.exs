defmodule Breakbench.Repo.Migrations.CreateFunctionQueuers do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION queuers (
        _space_id CHARACTER VARYING(255)
      ) RETURNS TABLE (
        game_mode_id UUID,
        matchmaking_queue_id UUID
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT DISTINCT ON (gmd.id, mmq.id)
          gmd.id AS game_mode_id,
          mmq.id AS matchmaking_queue_id
        FROM matchmaking_queues AS mmq
        RIGHT OUTER JOIN spaces AS spc ON
          ST_DWithin(mmq.geom::geography, spc.geom::geography, mmq.radius)
        INNER JOIN fields AS fld ON
          spc.id = fld.space_id
        RIGHT OUTER JOIN field_game_modes AS fgm ON
          fld.id = fgm.field_id
        RIGHT OUTER JOIN matchmaking_game_modes AS mgm ON
          mmq.id = mgm.matchmaking_queue_id
        INNER JOIN game_modes AS gmd ON
          gmd.id = fgm.game_mode_id AND
          gmd.id = mgm.game_mode_id
        RIGHT OUTER JOIN matchmaking_space_distance_matrices AS msd ON
          spc.id = msd.space_id AND
          mmq.id = msd.matchmaking_queue_id
        WHERE
          spc.id = _space_id;
      END $$;
    """

    execute """
      CREATE OR REPLACE FUNCTION queuers (
        _space_id CHARACTER VARYING(255),
        _game_mode_id UUID
      ) RETURNS TABLE (
        matchmaking_queue_id UUID
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          _queuers.matchmaking_queue_id
        FROM queuers(_space_id) AS _queuers
        WHERE
          _queuers.game_mode_id = _game_mode_id;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION queuers ( CHARACTER VARYING )"
    execute "DROP FUNCTION queuers ( CHARACTER VARYING, UUID )"
  end
end
