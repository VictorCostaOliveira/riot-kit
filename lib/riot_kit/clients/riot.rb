# frozen_string_literal: true

require 'erb'

require_relative '../http/client'
require_relative '../http/response'

module RiotKit
  module Clients
    class Riot
      RIOT_JSON = { 'Content-Type' => 'application/json' }.freeze

      def initialize(config: RiotKit.config)
        @config = config
        @routing_client = Http::Client.new(
          base_url: config.routing_base_url,
          headers: RIOT_JSON,
          timeout: config.http_timeout,
          logger: config.logger,
          retry_attempts: config.retry_attempts,
          retry_base_delay: config.retry_base_delay
        )
        @platform_client = Http::Client.new(
          base_url: config.platform_base_url,
          headers: RIOT_JSON,
          timeout: config.http_timeout,
          logger: config.logger,
          retry_attempts: config.retry_attempts,
          retry_base_delay: config.retry_base_delay
        )
      end

      def get_account_by_riot_id(game_name:, tag_line:)
        headers = riot_headers
        path = "/riot/account/v1/accounts/by-riot-id/#{encode(game_name)}/#{encode(tag_line)}"
        @routing_client.get(path, headers: headers)
      end

      def get_match_ids_by_puuid(puuid:, queue: nil, count: 100, start_time: nil, end_time: nil)
        headers = riot_headers
        query = { start: 0, count: count }
        query[:queue] = queue if queue
        query[:startTime] = start_time if start_time
        query[:endTime] = end_time if end_time
        path = "/lol/match/v5/matches/by-puuid/#{encode(puuid)}/ids"
        @routing_client.get(path, query: query, headers: headers)
      end

      def get_match(match_id:)
        headers = riot_headers
        path = "/lol/match/v5/matches/#{encode(match_id)}"
        @routing_client.get(path, headers: headers)
      end

      def get_ranked_entries_by_puuid(puuid:)
        headers = riot_headers
        path = "/lol/league/v4/entries/by-puuid/#{encode(puuid)}"
        @platform_client.get(path, headers: headers)
      end

      private

      def riot_headers
        key = @config.api_key
        raise Errors::InvalidParams, 'RIOT_API_KEY / config.api_key não configurado' if key.nil? || key.to_s.empty?

        RIOT_JSON.merge('X-Riot-Token' => key)
      end

      def encode(str)
        ERB::Util.url_encode(str.to_s.strip)
      end
    end
  end
end
