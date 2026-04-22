# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'
require_relative '../../helpers/riot/match_helpers'

module RiotKit
  module Services
    module Riot
      class MatchIds < RiotKit::Services::Base
        include RiotKit::Helpers::Riot::MatchHelpers

        steps :parse_riot_id, :fetch_puuid, :fetch_match_ids

        def initialize(nickname:, filter: 'ranked', client: nil, config: RiotKit.config)
          @nickname = nickname
          @filter = filter.to_s
          @client = client || Clients::Riot.new(config: config)
          @config = config
          @result = []
        end

        private

        def parse_riot_id
          parts = @nickname.to_s.split('#', 2)
          raise Errors::InvalidRiotId unless parts.size == 2

          @game_name, @tag_line = parts
        end

        def fetch_puuid
          response = @client.get_account_by_riot_id(game_name: @game_name, tag_line: @tag_line)
          raise Errors::AccountNotFound unless response.success?

          @puuid = response.result[:puuid]
        end

        def fetch_match_ids
          queue = QUEUE_ID[@filter.to_sym]
          raise Errors::InvalidParams, "Filtro inválido: #{@filter}" unless queue

          response = @client.get_match_ids_by_puuid(puuid: @puuid, queue: queue)
          @result = response.success? ? Array(response.result) : []
        end
      end
    end
  end
end
