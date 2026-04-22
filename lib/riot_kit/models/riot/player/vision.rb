# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Vision
          attr_reader :vision_score, :wards_placed, :wards_killed,
                      :detector_wards_placed, :vision_wards_bought, :stealth_wards_placed

          def initialize(**attrs)
            @vision_score = attrs[:vision_score]
            @wards_placed = attrs[:wards_placed]
            @wards_killed = attrs[:wards_killed]
            @detector_wards_placed = attrs[:detector_wards_placed]
            @vision_wards_bought = attrs[:vision_wards_bought]
            @stealth_wards_placed = attrs[:stealth_wards_placed]
          end

          def to_h
            {
              vision_score: vision_score,
              wards_placed: wards_placed,
              wards_killed: wards_killed,
              detector_wards_placed: detector_wards_placed,
              vision_wards_bought: vision_wards_bought,
              stealth_wards_placed: stealth_wards_placed
            }
          end
        end
      end
    end
  end
end
