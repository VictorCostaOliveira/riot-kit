# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Equipment
          attr_reader :summoner_spell_ids, :item_ids

          def initialize(**attrs)
            @summoner_spell_ids = attrs[:summoner_spell_ids]
            @item_ids = attrs[:item_ids]
          end

          def to_h
            {
              summoner_spell_ids: summoner_spell_ids,
              item_ids: item_ids
            }
          end
        end
      end
    end
  end
end
