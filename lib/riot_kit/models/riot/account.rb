# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Account
        attr_reader :puuid, :game_name, :tag_line

        def initialize(puuid:, game_name:, tag_line:)
          @puuid = puuid
          @game_name = game_name
          @tag_line = tag_line
        end

        def to_h
          { puuid: puuid, game_name: game_name, tag_line: tag_line }
        end

        def display_riot_id
          "#{game_name}##{tag_line}"
        end
      end
    end
  end
end
