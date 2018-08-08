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
          spc.id AS space_id,
          fgm.game_mode_id AS game_mode_id
        FROM spaces AS spc
        INNER JOIN areas ON
          spc.id = areas.space_id
        INNER JOIN fields AS fld ON
          areas.id = fld.area_id
        INNER JOIN field_game_modes AS fgm ON
          fld.id = fgm.field_id
        INNER JOIN game_modes AS gmd ON
          gmd.id = fgm.game_mode_id
        LEFT OUTER JOIN matchmaking_queues AS mmq ON
          ST_DWithin(mmq.geom::geography, spc.geom::geography, mmq.radius)
        INNER JOIN matchmaking_game_modes AS mgm ON
          mmq.id = mgm.matchmaking_queue_id
        RIGHT OUTER JOIN matchmaking_space_distance_matrices AS msd ON
          spc.id = msd.space_id AND
          mmq.id = msd.matchmaking_queue_id
        WHERE
          ST_DWithin(_geom::geography, spc.geom::geography, _radius) AND
          msd.duration <= _duration
        GROUP BY
          spc.id,
          fgm.game_mode_id,
          gmd.id
        HAVING
          COUNT(mmq.id) >= gmd.number_of_players
        ORDER BY
          ST_DistanceSphere(_geom, spc.geom);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION populated_spaces ( geometry, integer, integer )"
  end
end
