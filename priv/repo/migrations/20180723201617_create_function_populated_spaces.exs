defmodule Breakbench.Repo.Migrations.CreateFunctionPopulatedSpaces do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION populated_spaces(
        _geom geometry(Point,4326),
        _radius INTEGER,
        _duration INTEGER DEFAULT 3600
      ) RETURNS TABLE (
        space_id CHARACTER VARYING(255),
        game_mode_id UUID
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT
          sch.space_id, sch.game_mode_id
        FROM (
          SELECT
            spc.id AS space_id,
            gam.game_mode_id AS game_mode_id,
            searchrange(
              now() AT TIME ZONE spc.timezone,
              gmd.duration * INTERVAL '1 SEC',
              _margin => INTERVAL '2 HOURS'
            ) AS searchrange
          FROM spaces AS spc
          INNER JOIN areas ON
            spc.id = areas.space_id
          INNER JOIN game_areas AS gar ON
            areas.id = gar.area_id
          INNER JOIN game_area_modes AS gam ON
            gar.id = gam.game_area_id
          INNER JOIN game_modes AS gmd ON
            gmd.id = gam.game_mode_id
          LEFT OUTER JOIN (
            SELECT
              mmq.*,
              mmr.radius AS radius
            FROM matchmaking_queues AS mmq
            INNER JOIN matchmaking_rules AS mmr ON
              mmr.id = mmq.rule_id
          ) AS mmq ON
            ST_DWithin(mmq.geom::geography, spc.geom::geography, mmq.radius)
          INNER JOIN matchmaking_game_modes AS mgm ON
            mmq.id = mgm.matchmaking_queue_id
          INNER JOIN matchmaking_space_distance_matrices AS msd ON
            spc.id = msd.space_id AND
            mmq.id = msd.matchmaking_queue_id
          WHERE
            mmq.status = 'queued' AND
            ST_DWithin(_geom::geography, spc.geom::geography, _radius) AND
            msd.duration <= _duration
          GROUP BY
            spc.id,
            gam.game_mode_id,
            gmd.id
          HAVING
            COUNT(mmq.id) >= gmd.number_of_players
          ORDER BY
            AVG(msd.duration)
        ) sch
        WHERE (SELECT EXISTS (
          SELECT next_available(sch.space_id, sch.game_mode_id, sch.searchrange)
        ));
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION populated_spaces ( geometry, INTEGER, INTEGER )"
  end
end
