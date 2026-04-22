# frozen_string_literal: true

require 'forwardable'

require_relative 'player/stats'
require_relative 'player/combat'
require_relative 'player/economy'
require_relative 'player/vision'
require_relative 'player/objectives'
require_relative 'player/equipment'

module RiotKit
  module Models
    module Riot
      class Player
        extend Forwardable

        attr_reader :champion_id, :champion_name, :summoner_name, :riot_id_game_name, :riot_id_tagline, :team_id,
                    :current_user, :win, :team_position, :lane, :role, :champ_level, :stats, :combat, :economy, :vision, :objectives, :equipment

        def_delegators :stats, :kills, :deaths, :assists, :kda, :kill_participation,
                       :total_time_spent_dead, :longest_time_spent_living

        def_delegators :combat, :total_damage_dealt_to_champions, :physical_damage_dealt_to_champions,
                       :magic_damage_dealt_to_champions, :true_damage_dealt_to_champions,
                       :total_damage_taken, :physical_damage_taken, :magic_damage_taken,
                       :true_damage_taken, :damage_self_mitigated,
                       :time_ccing_others, :total_heal, :total_heals_on_teammates,
                       :total_damage_shielded_on_teammates,
                       :killing_sprees, :largest_killing_spree, :double_kills, :triple_kills,
                       :quadra_kills, :penta_kills, :largest_multi_kill, :solo_kills,
                       :skillshots_dodged, :skillshots_hit, :outnumbered_kills,
                       :survived_single_digit_hp

        def_delegators :economy, :gold_earned, :gold_spent,
                       :cs_total, :cs_per_minute, :total_minions_killed, :neutral_minions_killed,
                       :neutral_minions_ally_jungle, :neutral_minions_enemy_jungle,
                       :damage_per_minute, :gold_per_minute, :vision_score_per_minute,
                       :team_damage_percentage

        def_delegators :vision, :vision_score, :wards_placed, :wards_killed,
                       :detector_wards_placed, :vision_wards_bought, :stealth_wards_placed

        def_delegators :objectives, :turret_kills, :turret_takedowns, :inhibitor_kills, :inhibitor_takedowns,
                       :baron_kills, :baron_takedowns, :dragon_kills, :dragon_takedowns,
                       :rift_herald_takedowns,
                       :damage_dealt_to_buildings, :damage_dealt_to_objectives, :damage_dealt_to_turrets,
                       :first_blood_kill, :first_tower_kill

        def_delegators :equipment, :summoner_spell_ids, :item_ids

        def initialize(**attrs)
          assign_identity(attrs)
          @stats = Player::Stats.new(**attrs)
          @combat = Player::Combat.new(**attrs)
          @economy = Player::Economy.new(**attrs)
          @vision = Player::Vision.new(**attrs)
          @objectives = Player::Objectives.new(**attrs)
          @equipment = Player::Equipment.new(**attrs)
        end

        def display_riot_id
          return riot_id_game_name if riot_id_tagline.to_s.strip.empty?

          "#{riot_id_game_name}##{riot_id_tagline}"
        end

        def to_h
          identity_to_h
            .merge(stats.to_h)
            .merge(combat.to_h)
            .merge(economy.to_h)
            .merge(vision.to_h)
            .merge(objectives.to_h)
            .merge(equipment.to_h)
        end

        private

        def assign_identity(attrs)
          @champion_id = attrs[:champion_id]
          @champion_name = attrs[:champion_name]
          @summoner_name = attrs[:summoner_name]
          @riot_id_game_name = attrs[:riot_id_game_name]
          @riot_id_tagline = attrs[:riot_id_tagline]
          @team_id = attrs[:team_id]
          @current_user = attrs[:current_user]
          @win = attrs[:win]
          @team_position = attrs[:team_position]
          @lane = attrs[:lane]
          @role = attrs[:role]
          @champ_level = attrs[:champ_level]
        end

        def identity_to_h
          {
            champion_id: champion_id,
            champion_name: champion_name,
            summoner_name: summoner_name,
            riot_id_game_name: riot_id_game_name,
            riot_id_tagline: riot_id_tagline,
            team_id: team_id,
            current_user: current_user,
            win: win,
            team_position: team_position,
            lane: lane,
            role: role,
            champ_level: champ_level
          }
        end
      end
    end
  end
end
