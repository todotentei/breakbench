defmodule Breakbench.Repo.Migrations.CreateFunctionNextAv do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION next_available(
        _space_id CHARACTER VARYING(255),
        _game_mode_id UUID,
        _searchrange tsrange
      ) RETURNS TABLE (
        game_area_id UUID,
        available tsrange
      ) LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _opening_hours RECORD;
        _bookings tsrange[];
        _oph tsrange[];
        _temp JSON[];
        _return JSON[];
      BEGIN
        FOR _opening_hours IN
          SELECT
            _game_area_id AS game_area_id,
            _opening_hour AS opening_hour
          FROM (
            SELECT
              fld.id AS _game_area_id,
              UNNEST(opening_hours(fld.id, _searchrange)) AS _opening_hour,
              gmd.duration * INTERVAL '1 SEC' AS _duration
            FROM spaces AS spc
            INNER JOIN areas ON
              spc.id = areas.space_id
            INNER JOIN game_areas AS fld ON
              areas.id = fld.area_id
            INNER JOIN game_area_modes AS gam ON
              fld.id = gam.game_area_id
            INNER JOIN game_modes AS gmd ON
              gmd.id = gam.game_mode_id
            WHERE
              spc.id = _space_id AND
              gmd.id = _game_mode_id
          ) AS _opening_hours
          WHERE upper(_opening_hour) - lower(_opening_hour) >= _duration
        LOOP
          _oph = ARRAY[_opening_hours.opening_hour];

          SELECT ARRAY_AGG(tsrange)
          INTO _bookings
          FROM (
            SELECT
              tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')
            FROM bookings as bkg
            INNER JOIN affected_game_areas(_opening_hours.game_area_id) as aff ON
              bkg.game_area_id = aff.game_area_id AND
              _opening_hours.opening_hour && tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')

            UNION

            SELECT
              tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')
            FROM bookings AS bkg
            WHERE
              bkg.game_area_id = _opening_hours.game_area_id AND
              _opening_hours.opening_hour && tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')
          ) AS _bookings;

          IF _bookings IS NOT NULL THEN
            _oph = split(_oph, _bookings);
          END IF;

          SELECT
            ARRAY_AGG(JSON_BUILD_OBJECT(
              'game_area_id', _av.game_area_id,
              'available', _av.available
            ))
          FROM (
            SELECT
              _opening_hours.game_area_id AS game_area_id,
              UNNEST(_oph) AS available
          ) AS _av
          INTO _temp;

          _return = ARRAY_CAT(_return, _temp);
        END LOOP;

        RETURN QUERY SELECT
          *
        FROM json_to_recordset(array_to_json(_return)) AS _rtn
          ("game_area_id" UUID, available tsrange);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION next_available ( CHARACTER VARYING, UUID, tsrange )"
  end
end
