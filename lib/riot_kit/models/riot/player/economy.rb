# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Economy
          attr_reader :gold_earned, :gold_spent,
                      :cs_total, :cs_per_minute, :total_minions_killed, :neutral_minions_killed,
                      :neutral_minions_ally_jungle, :neutral_minions_enemy_jungle,
                      :damage_per_minute, :gold_per_minute, :vision_score_per_minute,
                      :team_damage_percentage

          def initialize(**attrs)
            @gold_earned = attrs[:gold_earned]
            @gold_spent = attrs[:gold_spent]
            @cs_total = attrs[:cs_total]
            @cs_per_minute = attrs[:cs_per_minute]
            @total_minions_killed = attrs[:total_minions_killed]
            @neutral_minions_killed = attrs[:neutral_minions_killed]
            @neutral_minions_ally_jungle = attrs[:neutral_minions_ally_jungle]
            @neutral_minions_enemy_jungle = attrs[:neutral_minions_enemy_jungle]
            @damage_per_minute = attrs[:damage_per_minute]
            @gold_per_minute = attrs[:gold_per_minute]
            @vision_score_per_minute = attrs[:vision_score_per_minute]
            @team_damage_percentage = attrs[:team_damage_percentage]
          end

          def to_h
            {
              gold_earned: gold_earned,
              gold_spent: gold_spent,
              cs_total: cs_total,
              cs_per_minute: cs_per_minute,
              total_minions_killed: total_minions_killed,
              neutral_minions_killed: neutral_minions_killed,
              neutral_minions_ally_jungle: neutral_minions_ally_jungle,
              neutral_minions_enemy_jungle: neutral_minions_enemy_jungle,
              damage_per_minute: damage_per_minute,
              gold_per_minute: gold_per_minute,
              vision_score_per_minute: vision_score_per_minute,
              team_damage_percentage: team_damage_percentage
            }
          end
        end
      end
    end
  end
end
