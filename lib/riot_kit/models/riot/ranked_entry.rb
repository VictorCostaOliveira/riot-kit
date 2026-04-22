# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class RankedEntry
        attr_reader :queue_type, :tier, :rank, :league_points, :wins, :losses,
                    :summoner_name, :puuid, :raw

        def self.from_api(hash)
          hash = RiotKit::Util::Symbolize.deep_symbolize_keys(hash) if hash.is_a?(Hash)
          new(
            queue_type: hash[:queueType],
            tier: hash[:tier],
            rank: hash[:rank],
            league_points: hash[:leaguePoints],
            wins: hash[:wins],
            losses: hash[:losses],
            summoner_name: hash[:summonerName],
            puuid: hash[:puuid],
            raw: hash
          )
        end

        def initialize(queue_type:, tier:, rank:, league_points:, wins:, losses:,
                       summoner_name: nil, puuid: nil, raw: {})
          @queue_type = queue_type
          @tier = tier
          @rank = rank
          @league_points = league_points
          @wins = wins
          @losses = losses
          @summoner_name = summoner_name
          @puuid = puuid
          @raw = raw
        end

        def to_h
          {
            queue_type: queue_type,
            tier: tier,
            rank: rank,
            league_points: league_points,
            wins: wins,
            losses: losses,
            summoner_name: summoner_name,
            puuid: puuid
          }
        end
      end
    end
  end
end
