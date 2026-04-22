# frozen_string_literal: true

require_relative '../base'
require_relative '../../registries/data_dragon'
require_relative '../../models/data_dragon/summoner_spell'

module RiotKit
  module Services
    module DataDragon
      class FetchSummonerSpells < RiotKit::Services::Base
        steps :lookup

        def initialize(spell_id:, registry: Registries::DataDragon.current)
          @spell_id = spell_id
          @registry = registry
        end

        private

        def lookup
          records = @registry.summoner_spells
          key = @spell_id.to_s
          raw = records[key]
          raise Errors::InvalidParams, "Spell não encontrado: #{@spell_id}" unless raw

          @result = Models::DataDragon::SummonerSpell.from_hash(raw)
        end
      end
    end
  end
end
