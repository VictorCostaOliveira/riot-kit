# frozen_string_literal: true

require_relative '../services/riot/fetch_account'
require_relative '../models/riot/lazy_match_entries'
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
        @matches_cache = {}
      end

      def puuid
        account.puuid
      end

      def display_riot_id
        account.display_riot_id
      end

      # Memoized per Player, filter, and limit. Returns a lazy {Enumerable} — match-detail GETs run
      # only while you iterate, so `matches.first` loads one detail (plus the match-id list API).
      # Passes `puuid` from `find` so the history step skips GET /accounts/by-riot-id.
      # Use `limit:` to cap how many distinct match ids may be detailed when you enumerate fully.
      def matches(filter = :ranked, reload: false, limit: Services::Riot::MatchHistory::DEFAULT_DETAIL_LIMIT)
        cache_key = [filter.to_sym, limit]
        return @matches_cache[cache_key] if !reload && @matches_cache.key?(cache_key)

        @matches_cache[cache_key] = Models::Riot::LazyMatchEntries.build(
          nickname: display_riot_id,
          filter: filter,
          puuid: puuid,
          limit: limit,
          config: @config
        )
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
