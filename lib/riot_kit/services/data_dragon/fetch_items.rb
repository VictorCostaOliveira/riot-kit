# frozen_string_literal: true

require_relative '../base'
require_relative '../../registries/data_dragon'
require_relative '../../models/data_dragon/item'

module RiotKit
  module Services
    module DataDragon
      class FetchItems < RiotKit::Services::Base
        MYTHIC_ITEM_IDS = [3152, 3190, 4644, 3068, 3001].freeze
        MYTHIC_RANGE = (6600..6699)
        BOOT_ITEM_IDS = [1001, 3006, 3009, 3047, 3111, 3117, 3158].freeze

        steps :lookup

        def initialize(item_id:, registry: Registries::DataDragon.current)
          @item_id = item_id
          @registry = registry
        end

        def self.categorize(item_ids, _registry: Registries::DataDragon.current)
          categories = { mythic: [], boots: [], legendary: [] }
          Array(item_ids).each do |raw_id|
            next if raw_id.nil? || raw_id.to_i.zero?

            id = raw_id.to_i
            if MYTHIC_ITEM_IDS.include?(id) || MYTHIC_RANGE.cover?(id)
              categories[:mythic] << id
            elsif BOOT_ITEM_IDS.include?(id)
              categories[:boots] << id
            else
              categories[:legendary] << id
            end
          end
          categories
        end

        private

        def lookup
          records = @registry.items
          key = @item_id.to_s
          raw = records[key]
          raise Errors::InvalidParams, "Item não encontrado: #{@item_id}" unless raw

          hash = raw.is_a?(Hash) ? raw : {}
          @result = Models::DataDragon::Item.from_hash(hash)
        end
      end
    end
  end
end
