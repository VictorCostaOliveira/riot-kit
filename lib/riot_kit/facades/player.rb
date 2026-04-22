# frozen_string_literal: true

require_relative '../services/riot/fetch_account'
require_relative '../services/riot/match_history'
require_relative '../services/riot/match_detail'
require_relative '../services/riot/fetch_ranked_data'
require_relative '../services/riot/fetch_avg_matches_per_week'

module RiotKit
  module Facades
    class Player
      def self.find(riot_id, config: RiotKit.config)
        account = Services::Riot::FetchAccount.call(riot_id: riot_id, config: config).value!
        new(account: account, config: config)
      end

      attr_reader :account

      def initialize(account:, config:)
        @account = account
        @config = config
      end

      def puuid
        account.puuid
      end

      def display_riot_id
        account.display_riot_id
      end

      def matches(filter = :ranked)
        Services::Riot::MatchHistory.call(
          nickname: display_riot_id,
          filter: filter,
          config: @config
        ).value!
      end

      def match(match_id)
        Services::Riot::MatchDetail.call(
          match_id: match_id,
          puuid: puuid,
          config: @config
        ).value!
      end

      def ranked
        Services::Riot::FetchRankedData.call(puuid: puuid, config: @config).value!
      end

      def avg_matches_per_week
        Services::Riot::FetchAvgMatchesPerWeek.call(puuid: puuid, config: @config).value!
      end
    end
  end
end
