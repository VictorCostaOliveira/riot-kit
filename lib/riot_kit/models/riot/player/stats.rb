# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Stats
          attr_reader :kills, :deaths, :assists,
                      :kda, :kill_participation,
                      :total_time_spent_dead, :longest_time_spent_living

          def initialize(**attrs)
            @kills = attrs[:kills]
            @deaths = attrs[:deaths]
            @assists = attrs[:assists]
            @kda = attrs[:kda]
            @kill_participation = attrs[:kill_participation]
            @total_time_spent_dead = attrs[:total_time_spent_dead]
            @longest_time_spent_living = attrs[:longest_time_spent_living]
          end

          def to_h
            {
              kills: kills,
              deaths: deaths,
              assists: assists,
              kda: kda,
              kill_participation: kill_participation,
              total_time_spent_dead: total_time_spent_dead,
              longest_time_spent_living: longest_time_spent_living
            }
          end
        end
      end
    end
  end
end
