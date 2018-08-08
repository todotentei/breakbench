defmodule Breakbench.Repo.Migrations.CreateFunctionFurthestQueuer do
  use Ecto.Migration

  def up do
    execute """
      CREATE OR REPLACE FUNCTION furthest_queuer (
        _space_id CHARACTER VARYING(255),
        _game_mode_id UUID
      ) RETURNS UUID LANGUAGE PLPGSQL
      AS $$
      DECLARE
        _number_of_players INTEGER;
      BEGIN
        -- Game mode maximum number of players
        SELECT
          gmd.number_of_players
        FROM game_modes AS gmd
        WHERE
          gmd.id = _game_mode_id
        INTO _number_of_players;

        -- Order matchmaking queue by inserted_at
        -- Then trim the queue size to the limit number of players
        -- Return matchmaking queue id with the longest distance
        RETURN
          _queuers.matchmaking_queue_id
        FROM (
          SELECT
            mmq.id AS matchmaking_queue_id,
            msd.distance AS distance
          FROM queuers(_space_id, _game_mode_id) AS que
          INNER JOIN matchmaking_queues AS mmq ON
            mmq.id = que.matchmaking_queue_id
          INNER JOIN matchmaking_space_distance_matrices AS msd ON
            msd.space_id = _space_id AND
            mmq.id = msd.matchmaking_queue_id
          INNER JOIN game_modes AS gmd ON
            gmd.id = _game_mode_id
          ORDER BY
            mmq.inserted_at,
            msd.distance
          LIMIT _number_of_players
        ) AS _queuers
        ORDER BY distance DESC
        LIMIT 1;
      END $$;
    """
  end

  def down do
    execute "DROP FUNCTION furthest_queuer ( CHARACTER VARYING, UUID )"
  end
end
