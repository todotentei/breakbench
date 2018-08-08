defmodule Breakbench.FieldFactory do
  defmacro __using__ _ do
    quote do
      alias Breakbench.Places.{
        AffectedField, Field, FieldClosingHour, FieldDynamicPricing,
        FieldGameMode
      }

      def affected_field_factory do
        %AffectedField{
          field: build(:field),
          affected: build(:field)
        }
      end

      def field_factory do
        %Field{
          id: sequence(:id, &"field-#{&1}"),
          name: "name",
          area: build(:area),
          inserted_at: NaiveDateTime.utc_now,
          updated_at: NaiveDateTime.utc_now
        }
      end

      def field_closing_hour_factory do
        %FieldClosingHour{
          time_block: build(:time_block),
          field: build(:field)
        }
      end

      def field_dynamic_pricing_factory do
        %FieldDynamicPricing{
          time_block: build(:time_block),
          field: build(:field),
          price: 1000
        }
      end

      def field_game_mode_factory do
        %FieldGameMode{
          field: build(:field),
          game_mode: build(:game_mode)
        }
      end
    end
  end
end
