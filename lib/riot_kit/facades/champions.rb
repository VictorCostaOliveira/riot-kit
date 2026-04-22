# frozen_string_literal: true

require_relative '../services/data_dragon/fetch_champions'

module RiotKit
  module Facades
    class Champions
      def self.find(query, registry: Registries::DataDragon.current)
        Services::DataDragon::FetchChampions.call(query: query, registry: registry).value!
      end
    end
  end
end
