# frozen_string_literal: true

require_relative '../services/data_dragon/fetch_runes'

module RiotKit
  module Facades
    class Runes
      def self.find(rune_id, registry: Registries::DataDragon.current)
        Services::DataDragon::FetchRunes.call(rune_id: rune_id, registry: registry).value!
      end
    end
  end
end
