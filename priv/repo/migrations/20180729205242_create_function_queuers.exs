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
        RETURN QUERY SELECT
          _queuers.game_mode_id,
          _queuers.matchmaking_queue_id
        FROM (
          WITH space_game_modes AS (
            SELECT DISTINCT
              gam.game_mode_id AS id
            FROM areas AS aaa
            INNER JOIN game_areas AS gar ON
              aaa.id = gar.area_id
            INNER JOIN game_area_modes AS gam ON
              gar.id = gam.game_area_id
            WHERE aaa.space_id = _space_id
          )
          SELECT
            sgm.id AS game_mode_id,
            mmq.id AS matchmaking_queue_id
          FROM spaces AS spc
          LEFT OUTER JOIN matchmaking_queues AS mmq ON
            ST_DWithin(spc.geom::geography, mmq.geom::geography, rle.radius)
          INNER JOIN matchmaking_rules AS rle ON
            rle.id = mmq.rule_id
          INNER JOIN matchmaking_game_modes AS mgm ON
            mmq.id = mgm.matchmaking_queue_id
          INNER JOIN space_game_modes AS sgm ON
            mgm.game_mode_id = sgm.id
          RIGHT OUTER JOIN matchmaking_space_distance_matrices AS msd ON
            spc.id = msd.space_id AND
            mmq.id = msd.matchmaking_queue_id
          WHERE
            spc.id = _space_id AND
            mmq.status = 'queued'
          ORDER BY
            CASE WHEN AGE(now() AT TIME ZONE 'UTC', mmq.inserted_at) > INTERVAL '5 MIN'
            THEN 0 ELSE 1 END,
            msd.duration,
            mmq.inserted_at
        ) _queuers;
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
