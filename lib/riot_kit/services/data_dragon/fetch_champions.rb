# frozen_string_literal: true

require_relative '../base'
require_relative '../../registries/data_dragon'
require_relative '../../models/data_dragon/champion'

module RiotKit
  module Services
    module DataDragon
      class FetchChampions < RiotKit::Services::Base
        steps :lookup

        def initialize(query:, registry: Registries::DataDragon.current)
          @query = query
          @registry = registry
        end

        private

        def lookup
          records = @registry.champions
          champion = find_in_records(records)
          raise Errors::InvalidParams, "Campeão não encontrado: #{@query}" unless champion

          @result = Models::DataDragon::Champion.from_hash(champion)
        end

        def find_in_records(records)
          q = @query.to_s.strip
          return records[q] if records.key?(q)

          as_i = Integer(q, exception: false)
          return records[as_i.to_s] if as_i

          down = q.downcase
          records.each_value do |value|
            next unless value.is_a?(Hash)

            sym = RiotKit::Util::Symbolize.deep_symbolize_keys(value)
            return sym if sym[:name].to_s.casecmp(q).zero?
            return sym if sym[:key].to_s == q
            return sym if sym[:id].to_s == q
            return sym if sym[:name].to_s.downcase == down
          end
          nil
        end
      end
    end
  end
end
