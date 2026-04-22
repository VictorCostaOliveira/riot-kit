# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'
require_relative '../../helpers/riot/match_helpers'
require_relative '../../models/riot/match_detail'
require_relative '../../models/riot/match_team'
require_relative '../../models/riot/player'

module RiotKit
  module Services
    module Riot
      class MatchDetail < RiotKit::Services::Base
        include RiotKit::Helpers::Riot::MatchHelpers

        steps :fetch_match, :build_detail

        attr_reader :raw_data

        def initialize(match_id:, puuid:, raw_data: nil, client: nil, config: RiotKit.config)
          @match_id = match_id
          @puuid = puuid
          @raw_data = raw_data
          @client = client || Clients::Riot.new(config: config)
          @config = config
          @result = nil
        end

        private

        def fetch_match
          return if @raw_data

          response = @client.get_match(match_id: @match_id)
          raise Errors::MatchNotFound unless response.success?

          @raw_data = response.result
        end

        def build_detail
          info = @raw_data[:info] || {}
          meta = @raw_data[:metadata] || {}
          @game_duration_seconds = info[:gameDuration].to_i
          @result = Models::Riot::MatchDetail.new(
            match_id: meta[:matchId],
            game_duration_seconds: @game_duration_seconds,
            queue_id: info[:queueId],
            queue_label: queue_label_for(info[:queueId]),
            game_creation: info[:gameCreation],
            teams: build_teams(info),
            participants: build_participants(info)
          )
        end

        def build_teams(info)
          info[:teams].to_a.map do |team|
            team_participants = participants_for_team(info, team[:teamId])
            Models::Riot::MatchTeam.new(**base_team_attrs(team, team_participants), **team_objective_attrs(team))
          end
        end

        def base_team_attrs(team, team_participants)
          {
            team_id: team[:teamId],
            win: team[:win],
            kills: team_participants.sum { |participant_row| participant_row[:kills].to_i },
            deaths: team_participants.sum { |participant_row| participant_row[:deaths].to_i },
            assists: team_participants.sum { |participant_row| participant_row[:assists].to_i }
          }
        end

        def team_objective_attrs(team)
          objectives = team[:objectives] || {}
          {
            baron_kills: objectives.dig(:baron, :kills).to_i,
            dragon_kills: objectives.dig(:dragon, :kills).to_i,
            tower_kills: objectives.dig(:tower, :kills).to_i,
            inhibitor_kills: objectives.dig(:inhibitor, :kills).to_i,
            rift_herald_kills: objectives.dig(:riftHerald, :kills).to_i
          }
        end

        def participants_for_team(info, team_id)
          info[:participants].to_a.select { |participant_row| participant_row[:teamId] == team_id }
        end

        def build_participants(info)
          info[:participants].to_a.map { |participant_row| build_participant(participant_row) }
        end

        def build_participant(participant)
          challenges = participant[:challenges] || {}
          cs_count = cs_total_for(participant)

          Models::Riot::Player.new(
            **identity_attrs(participant),
            **kda_farm_attrs(participant, cs_count),
            **gold_attrs(participant),
            **damage_dealt_attrs(participant),
            **damage_taken_attrs(participant),
            **support_attrs(participant),
            **vision_attrs(participant, challenges),
            **objective_attrs(participant, challenges),
            **highlight_attrs(participant, challenges),
            **time_attrs(participant),
            **riot_metric_attrs(challenges),
            **equipment_attrs(participant)
          )
        end

        def identity_attrs(participant)
          {
            champion_id: participant[:championId],
            champion_name: participant[:championName],
            summoner_name: participant[:riotIdGameName] || participant[:summonerName],
            riot_id_game_name: participant[:riotIdGameName],
            riot_id_tagline: participant[:riotIdTagline],
            team_id: participant[:teamId],
            current_user: participant[:puuid] == @puuid,
            win: participant[:win],
            team_position: participant[:teamPosition],
            lane: participant[:lane],
            role: participant[:role],
            champ_level: participant[:champLevel].to_i
          }
        end

        def kda_farm_attrs(participant, cs_count)
          {
            kills: participant[:kills].to_i,
            deaths: participant[:deaths].to_i,
            assists: participant[:assists].to_i,
            cs_total: cs_count,
            cs_per_minute: cs_per_minute(cs_count, @game_duration_seconds),
            total_minions_killed: participant[:totalMinionsKilled].to_i,
            neutral_minions_killed: participant[:neutralMinionsKilled].to_i,
            neutral_minions_ally_jungle: participant[:totalAllyJungleMinionsKilled].to_i,
            neutral_minions_enemy_jungle: participant[:totalEnemyJungleMinionsKilled].to_i
          }
        end

        def gold_attrs(participant)
          {
            gold_earned: participant[:goldEarned].to_i,
            gold_spent: participant[:goldSpent].to_i
          }
        end

        def damage_dealt_attrs(participant)
          {
            total_damage_dealt_to_champions: participant[:totalDamageDealtToChampions].to_i,
            physical_damage_dealt_to_champions: participant[:physicalDamageDealtToChampions].to_i,
            magic_damage_dealt_to_champions: participant[:magicDamageDealtToChampions].to_i,
            true_damage_dealt_to_champions: participant[:trueDamageDealtToChampions].to_i
          }
        end

        def damage_taken_attrs(participant)
          {
            total_damage_taken: participant[:totalDamageTaken].to_i,
            physical_damage_taken: participant[:physicalDamageTaken].to_i,
            magic_damage_taken: participant[:magicDamageTaken].to_i,
            true_damage_taken: participant[:trueDamageTaken].to_i,
            damage_self_mitigated: participant[:damageSelfMitigated].to_i
          }
        end

        def support_attrs(participant)
          {
            time_ccing_others: participant[:timeCCingOthers].to_i,
            total_heal: participant[:totalHeal].to_i,
            total_heals_on_teammates: participant[:totalHealsOnTeammates].to_i,
            total_damage_shielded_on_teammates: participant[:totalDamageShieldedOnTeammates].to_i
          }
        end

        def vision_attrs(participant, challenges)
          {
            vision_score: participant[:visionScore].to_i,
            wards_placed: participant[:wardsPlaced].to_i,
            wards_killed: participant[:wardsKilled].to_i,
            detector_wards_placed: participant[:detectorWardsPlaced].to_i,
            vision_wards_bought: participant[:visionWardsBoughtInGame].to_i,
            stealth_wards_placed: challenges[:stealthWardsPlaced]
          }
        end

        def objective_attrs(participant, challenges)
          {
            turret_kills: participant[:turretKills].to_i,
            turret_takedowns: participant[:turretTakedowns].to_i,
            inhibitor_kills: participant[:inhibitorKills].to_i,
            inhibitor_takedowns: participant[:inhibitorTakedowns].to_i,
            baron_kills: participant[:baronKills].to_i,
            dragon_kills: participant[:dragonKills].to_i,
            damage_dealt_to_buildings: participant[:damageDealtToBuildings].to_i,
            damage_dealt_to_objectives: participant[:damageDealtToObjectives].to_i,
            damage_dealt_to_turrets: participant[:damageDealtToTurrets].to_i,
            first_blood_kill: participant[:firstBloodKill],
            first_tower_kill: participant[:firstTowerKill],
            baron_takedowns: challenges[:baronTakedowns] || participant[:baronTakedowns],
            dragon_takedowns: challenges[:dragonTakedowns],
            rift_herald_takedowns: challenges[:riftHeraldTakedowns]
          }
        end

        def highlight_attrs(participant, challenges)
          {
            killing_sprees: participant[:killingSprees].to_i,
            largest_killing_spree: participant[:largestKillingSpree].to_i,
            double_kills: participant[:doubleKills].to_i,
            triple_kills: participant[:tripleKills].to_i,
            quadra_kills: participant[:quadraKills].to_i,
            penta_kills: participant[:pentaKills].to_i,
            largest_multi_kill: participant[:largestMultiKill].to_i,
            solo_kills: challenges[:soloKills],
            skillshots_dodged: challenges[:skillshotsDodged],
            skillshots_hit: challenges[:skillshotsHit],
            outnumbered_kills: challenges[:outnumberedKills],
            survived_single_digit_hp: challenges[:survivedSingleDigitHpCount]
          }
        end

        def time_attrs(participant)
          {
            total_time_spent_dead: participant[:totalTimeSpentDead].to_i,
            longest_time_spent_living: participant[:longestTimeSpentLiving].to_i
          }
        end

        def riot_metric_attrs(challenges)
          {
            kda: challenges[:kda],
            kill_participation: challenges[:killParticipation],
            damage_per_minute: challenges[:damagePerMinute],
            gold_per_minute: challenges[:goldPerMinute],
            vision_score_per_minute: challenges[:visionScorePerMinute],
            team_damage_percentage: challenges[:teamDamagePercentage]
          }
        end

        def equipment_attrs(participant)
          {
            summoner_spell_ids: [participant[:summoner1Id], participant[:summoner2Id]].compact,
            item_ids: item_ids_for(participant)
          }
        end
      end
    end
  end
end
