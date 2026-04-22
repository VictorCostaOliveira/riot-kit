# frozen_string_literal: true

require_relative '../http/client'

module RiotKit
  module Clients
    class DataDragon
      BASE_URL = 'https://ddragon.leagueoflegends.com'

      def initialize(config: RiotKit.config)
        @config = config
        @client = Http::Client.new(
          base_url: BASE_URL,
          headers: { 'Content-Type' => 'application/json' },
          timeout: config.http_timeout,
          logger: config.logger,
          retry_attempts: config.retry_attempts,
          retry_base_delay: config.retry_base_delay
        )
      end

      def get_versions
        @client.get('/api/versions.json')
      end

      def get_items(version:, locale: 'pt_BR')
        path = "/cdn/#{version}/data/#{locale}/item.json"
        response = @client.get(path)
        return response if response.success?

        @client.get("/cdn/#{version}/data/en_US/item.json")
      end

      def get_champions(version:, locale: 'pt_BR')
        path = "/cdn/#{version}/data/#{locale}/champion.json"
        response = @client.get(path)
        return response if response.success?

        @client.get("/cdn/#{version}/data/en_US/champion.json")
      end

      def get_summoner_spells(version:, locale: 'pt_BR')
        path = "/cdn/#{version}/data/#{locale}/summoner.json"
        response = @client.get(path)
        return response if response.success?

        @client.get("/cdn/#{version}/data/en_US/summoner.json")
      end

      def get_runes(version:, locale: 'pt_BR')
        path = "/cdn/#{version}/data/#{locale}/runesReforged.json"
        response = @client.get(path)
        return response if response.success?

        @client.get("/cdn/#{version}/data/en_US/runesReforged.json")
      end
    end
  end
end
