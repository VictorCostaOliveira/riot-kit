# frozen_string_literal: true

require_relative '../services/data_dragon/fetch_summoner_spells'

module RiotKit
  module Facades
    class SummonerSpells
      def self.find(spell_id, registry: Registries::DataDragon.current)
        Services::DataDragon::FetchSummonerSpells.call(spell_id: spell_id, registry: registry).value!
      end
    end
  end
end
