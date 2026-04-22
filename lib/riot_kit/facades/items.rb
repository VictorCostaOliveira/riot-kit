# frozen_string_literal: true

require_relative '../services/data_dragon/fetch_items'

module RiotKit
  module Facades
    class Items
      def self.find(item_id, registry: Registries::DataDragon.current)
        Services::DataDragon::FetchItems.call(item_id: item_id, registry: registry).value!
      end

      def self.categorize(item_ids, registry: Registries::DataDragon.current)
        Services::DataDragon::FetchItems.categorize(item_ids, _registry: registry)
      end
    end
  end
end
