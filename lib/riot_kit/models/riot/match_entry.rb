# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class MatchEntry
        attr_reader :match_id, :queue_id, :game_creation, :champion_id, :champion_name, :win,
                    :kills, :deaths, :assists, :cs_total, :cs_per_minute,
                    :game_duration_seconds, :queue_label, :summoner_spell_ids,
                    :item_ids, :participant_summaries, :puuid

        def initialize(match_id:, queue_id:, game_creation:, champion_id:, win:, kills:, deaths:, assists:, cs_total:,
                       cs_per_minute:, game_duration_seconds:, queue_label:, summoner_spell_ids:, item_ids:, participant_summaries:, champion_name: nil, puuid: nil)
          @match_id = match_id
          @queue_id = queue_id
          @game_creation = game_creation
          @champion_id = champion_id
          @champion_name = champion_name
          @win = win
          @kills = kills
          @deaths = deaths
          @assists = assists
          @cs_total = cs_total
          @cs_per_minute = cs_per_minute
          @game_duration_seconds = game_duration_seconds
          @queue_label = queue_label
          @summoner_spell_ids = summoner_spell_ids
          @item_ids = item_ids
          @participant_summaries = participant_summaries
          @puuid = puuid
        end

        def ==(other)
          other.is_a?(self.class) && match_id == other.match_id
        end

        def to_h
          {
            match_id: match_id,
            queue_id: queue_id,
            game_creation: game_creation,
            champion_id: champion_id,
            champion_name: champion_name,
            win: win,
            kills: kills,
            deaths: deaths,
            assists: assists,
            cs_total: cs_total,
            cs_per_minute: cs_per_minute,
            game_duration_seconds: game_duration_seconds,
            queue_label: queue_label,
            summoner_spell_ids: summoner_spell_ids,
            item_ids: item_ids,
            participant_summaries: participant_summaries,
            puuid: puuid
          }
        end

        alias to_cache_hash to_h

        def details(client: nil, config: RiotKit.config)
          return nil if puuid.to_s.strip.empty? || match_id.to_s.strip.empty?

          ::RiotKit::Services::Riot::MatchDetail.call(
            match_id: match_id,
            puuid: puuid,
            client: client,
            config: config
          ).value!
        rescue ::RiotKit::Errors::MatchNotFound
          nil
        end
      end
    end
  end
end
