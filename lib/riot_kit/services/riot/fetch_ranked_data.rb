# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'
require_relative '../../models/riot/ranked_entry'

module RiotKit
  module Services
    module Riot
      class FetchRankedData < RiotKit::Services::Base
        steps :validate_puuid, :fetch_entries

        def initialize(puuid:, client: nil, config: RiotKit.config)
          @puuid = puuid
          @client = client || Clients::Riot.new(config: config)
          @config = config
          @result = []
        end

        private

        def validate_puuid
          raise Errors::MissingPuuid if @puuid.nil? || @puuid.to_s.strip.empty?
        end

        def fetch_entries
          response = @client.get_ranked_entries_by_puuid(puuid: @puuid)
          raise Errors::RiotApiError unless response.success?

          entries = Array(response.result)
          @result = entries.map { |row| Models::Riot::RankedEntry.from_api(row) }
        end
      end
    end
  end
end
