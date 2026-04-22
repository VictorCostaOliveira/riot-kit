# frozen_string_literal: true

require_relative '../base'
require_relative '../../registries/data_dragon'
require_relative '../../models/data_dragon/rune'

module RiotKit
  module Services
    module DataDragon
      class FetchRunes < RiotKit::Services::Base
        steps :lookup

        def initialize(rune_id:, registry: Registries::DataDragon.current)
          @rune_id = rune_id
          @registry = registry
        end

        private

        def lookup
          records = @registry.runes
          key = @rune_id.to_s
          raw = records[key]
          raise Errors::InvalidParams, "Runa não encontrada: #{@rune_id}" unless raw

          @result = Models::DataDragon::Rune.from_hash(raw)
        end
      end
    end
  end
end
