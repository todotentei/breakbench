defmodule Breakbench.Repo.Migrations.CreateFunctionSpaceWithin do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION space_within(
        _geom geometry(Point,4326),
        _radius INTEGER,
        _game_modes UUID[]
      ) RETURNS TABLE (
        space_id CHARACTER VARYING(255)
      ) LANGUAGE PLPGSQL
      AS $$
      BEGIN
        RETURN QUERY SELECT DISTINCT
          _space.id
        FROM (
          SELECT
            spc.*, now() AT TIME ZONE spc.timezone AS now
          FROM spaces AS spc
          INNER JOIN areas AS aaa ON
            spc.id = aaa.space_id
          INNER JOIN game_areas AS gaa ON
            aaa.id = gaa.area_id
          INNER JOIN game_area_modes AS gam ON
            gaa.id = gam.game_area_id
          WHERE
            ST_DWithin(_geom::geography, spc.geom::geography, _radius) AND
            gam.game_mode_id = ANY(_game_modes)
        ) AS _space
        LEFT OUTER JOIN space_opening_hours AS soh ON
          _space.id = soh.space_id
        LEFT OUTER JOIN time_blocks AS tbk ON
          tbk.id = soh.time_block_id
        WHERE
          _space.now::DATE
            <@ daterange(tbk.from_date, tbk.through_date, '[]') AND
          int4range(EXTRACT(EPOCH FROM _space.now::TIME(0))::INTEGER, 86400, '[)')
            && int4range(tbk.start_time, tbk.end_time, '[)');
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION space_within ( geometry, INTEGER, UUID[] )"
  end
end
