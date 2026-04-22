# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'

module RiotKit
  module Services
    module Riot
      class FetchAvgMatchesPerWeek < RiotKit::Services::Base
        WEEKS = 4
        SECONDS_PER_WEEK = 60 * 60 * 24 * 7

        steps :fetch_match_ids, :calculate_average

        def initialize(puuid:, client: nil, config: RiotKit.config)
          @puuid = puuid
          @client = client || Clients::Riot.new(config: config)
          @config = config
          @match_ids = []
        end

        private

        def fetch_match_ids
          response = @client.get_match_ids_by_puuid(
            puuid: @puuid,
            start_time: start_timestamp,
            count: 100
          )
          @match_ids = response.success? ? Array(response.result) : []
        end

        def calculate_average
          @result = (@match_ids.size / WEEKS.to_f).round
        end

        def start_timestamp
          Time.now.to_i - (WEEKS * SECONDS_PER_WEEK)
        end
      end
    end
  end
end
