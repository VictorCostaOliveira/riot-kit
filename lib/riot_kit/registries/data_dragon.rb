# frozen_string_literal: true

require 'json'

module RiotKit
  module Registries
    class DataDragon
      DATA_DIR = File.expand_path('../data/data_dragon', __dir__)

      class << self
        attr_writer :current

        def current
          @current ||= new
        end

        def reload!
          @current = nil
        end
      end

      def version
        @version ||= File.read(File.join(DATA_DIR, 'version.txt')).strip
      end

      def items
        @items ||= load_records('items.json')
      end

      def champions
        @champions ||= load_records('champions.json')
      end

      def summoner_spells
        @summoner_spells ||= load_records('summoner_spells.json')
      end

      def runes
        @runes ||= load_records('runes.json')
      end

      private

      def load_records(filename)
        path = File.join(DATA_DIR, filename)
        raw = JSON.parse(File.read(path), symbolize_names: true)
        raw.transform_keys(&:to_s)
      rescue Errno::ENOENT, JSON::ParserError => e
        raise Errors::DataDragonError, "Falha ao carregar #{filename}: #{e.message}"
      end
    end
  end
end
