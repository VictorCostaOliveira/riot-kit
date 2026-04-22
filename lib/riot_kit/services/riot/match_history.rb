# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'
require_relative '../../helpers/riot/match_helpers'
require_relative '../../models/riot/match_entry'

module RiotKit
  module Services
    module Riot
      class MatchHistory < RiotKit::Services::Base
        include RiotKit::Helpers::Riot::MatchHelpers

        steps :parse_riot_id, :fetch_puuid, :fetch_match_ids, :build_entries

        def initialize(nickname:, filter: 'ranked', match_ids: nil, client: nil, config: RiotKit.config)
          @nickname = nickname
          @filter = filter.to_s
          @match_ids = match_ids # nil => fetch IDs via API; Array => use provided IDs
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
          return if match_ids_provided?

          queue = QUEUE_ID[@filter.to_sym]
          raise Errors::InvalidParams, "Filtro inválido: #{@filter}" unless queue

          response = @client.get_match_ids_by_puuid(puuid: @puuid, queue: queue)
          @match_ids = response.success? ? Array(response.result) : []
        end

        def build_entries
          @result = @match_ids.first(20).filter_map { |match_id| build_entry_for(match_id) }
        end

        def build_entry_for(match_id)
          response = @client.get_match(match_id: match_id)
          return nil unless response.success?

          build_entry(response.result)
        end

        def match_ids_provided?
          @match_ids.is_a?(Array) && !@match_ids.empty?
        end

        def build_entry(data)
          info = data[:info] || {}
          meta = data[:metadata] || {}
          participant = find_participant(info)
          return nil if participant.nil?

          duration = info[:gameDuration].to_i
          cs_count = cs_total_for(participant)
          build_entry_struct(meta, info, participant, cs_count, duration)
        end

        def build_entry_struct(meta, info, participant, cs_count, duration)
          Models::Riot::MatchEntry.new(
            **base_entry_attrs(meta, info, participant, cs_count, duration),
            participant_summaries: participant_summaries_for(info),
            puuid: @puuid
          )
        end

        def base_entry_attrs(meta, info, participant, cs_count, duration)
          {
            match_id: meta[:matchId],
            queue_id: info[:queueId],
            game_creation: info[:gameCreation],
            champion_id: participant[:championId],
            champion_name: participant[:championName],
            win: participant[:win],
            kills: participant[:kills].to_i,
            deaths: participant[:deaths].to_i,
            assists: participant[:assists].to_i,
            cs_total: cs_count,
            cs_per_minute: cs_per_minute(cs_count, duration),
            game_duration_seconds: duration,
            queue_label: queue_label_for(info[:queueId]),
            summoner_spell_ids: summoner_spell_ids_for(participant),
            item_ids: item_ids_for(participant)
          }
        end

        def find_participant(info)
          info[:participants].to_a.find { |participant_row| participant_row[:puuid] == @puuid }
        end

        def summoner_spell_ids_for(participant)
          [participant[:summoner1Id], participant[:summoner2Id]].compact
        end

        def participant_summaries_for(info)
          info[:participants].to_a.map do |participant_row|
            {
              champion_id: participant_row[:championId],
              champion_name: participant_row[:championName],
              summoner_name: participant_row[:riotIdGameName] || participant_row[:summonerName],
              team_id: participant_row[:teamId],
              current_user: participant_row[:puuid] == @puuid
            }
          end
        end
      end
    end
  end
end
