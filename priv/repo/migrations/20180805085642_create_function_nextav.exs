defmodule Breakbench.Repo.Migrations.CreateFunctionNextAv do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION nextav (
        _space_id CHARACTER VARYING(255),
        _game_mode_id UUID,
        _delay INTERVAL DEFAULT '15 MIN'::INTERVAL,
        _margin INTERVAL DEFAULT '45 MIN'::INTERVAL
      ) RETURNS TABLE (
        field_id CHARACTER VARYING(255),
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
            _field_id AS field_id,
            _opening_hour AS opening_hour
          FROM (
            SELECT
              fld.id AS _field_id,
              -- now + the furthest queuer travel duration
              UNNEST(opening_hours(fld.id, searchrange(
                now() AT TIME ZONE spc.timezone + msd.duration * INTERVAL '1 SEC',
                gmd.duration * INTERVAL '1 SEC',
                _delay => _delay, _margin => _margin
              ))) AS _opening_hour,
              gmd.duration * INTERVAL '1 SEC' AS _duration
            FROM spaces AS spc
            INNER JOIN areas ON
              spc.id = areas.space_id
            INNER JOIN fields AS fld ON
              areas.id = fld.area_id
            INNER JOIN field_game_modes AS fgm ON
              fld.id = fgm.field_id
            INNER JOIN game_modes AS gmd ON
              gmd.id = fgm.game_mode_id
            FULL JOIN matchmaking_space_distance_matrices AS msd ON
              msd.space_id = _space_id AND
              msd.matchmaking_queue_id = furthest_queuer(_space_id, _game_mode_id)
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
            INNER JOIN affected_fields(_opening_hours.field_id) as aff ON
              bkg.field_id = aff.field_id AND
              _opening_hours.opening_hour && tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')

            UNION

            SELECT
              tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')
            FROM bookings AS bkg
            WHERE
              bkg.field_id = _opening_hours.field_id AND
              _opening_hours.opening_hour && tsrange(kickoff, kickoff + duration * INTERVAL '1 SEC', '[)')
          ) AS _bookings;

          IF _bookings IS NOT NULL THEN
            _oph = split(_oph, _bookings);
          END IF;

          SELECT
            ARRAY_AGG(JSON_BUILD_OBJECT(
              'field_id', _av.field_id,
              'available', _av.available
            ))
          FROM (
            SELECT
              _opening_hours.field_id AS field_id,
              UNNEST(_oph) AS available
          ) AS _av
          INTO _temp;

          _return = ARRAY_CAT(_return, _temp);
        END LOOP;

        RETURN QUERY SELECT
          *
        FROM json_to_recordset(array_to_json(_return)) AS _rtn
          ("field_id" CHARACTER VARYING(255), available tsrange);
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION nextav ( CHARACTER VARYING, UUID, INTERVAL, INTERVAL )"
  end
end
