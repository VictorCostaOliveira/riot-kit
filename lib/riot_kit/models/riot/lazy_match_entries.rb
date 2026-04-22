# frozen_string_literal: true

require_relative '../../services/riot/match_history'

module RiotKit
  module Models
    module Riot
      # Lazy Enumerable over match IDs: `get_match` runs only while you iterate, so
      # `player.matches.first` triggers at most one match-detail request (plus the match-id list API).
      class LazyMatchEntries
        include Enumerable

        def self.build(nickname:, filter:, puuid:, limit:, config:)
          history = Services::Riot::MatchHistory.new(
            nickname: nickname,
            filter: filter,
            puuid: puuid,
            limit: limit,
            config: config
          )
          history.send(:prepare_ids_phase!)
          new(match_history: history)
        end

        def initialize(match_history:)
          @match_history = match_history
          @detail_cache = {}
        end

        def each
          return enum_for(__method__) unless block_given?

          id_list.each do |match_id|
            entry = fetch_or_cache_entry(match_id)
            yield entry if entry
          end
        end

        def first(count = nil)
          return super unless count.nil?

          return @first_memo if defined?(@first_memo)

          @first_memo = super()
        end

        private

        def id_list
          @match_history.send(:ids_for_detail_fetch)
        end

        def fetch_or_cache_entry(match_id)
          return @detail_cache[match_id] if @detail_cache.key?(match_id)

          entry = @match_history.send(:build_entry_for, match_id)
          @detail_cache[match_id] = entry
          entry
        end
      end
    end
  end
end
