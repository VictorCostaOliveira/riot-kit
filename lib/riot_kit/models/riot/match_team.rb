# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class MatchTeam
        attr_reader :team_id, :win, :kills, :deaths, :assists,
                    :baron_kills, :dragon_kills, :tower_kills,
                    :inhibitor_kills, :rift_herald_kills

        def initialize(team_id:, win:, kills:, deaths:, assists:,
                       baron_kills:, dragon_kills:, tower_kills:,
                       inhibitor_kills:, rift_herald_kills:)
          @team_id = team_id
          @win = win
          @kills = kills
          @deaths = deaths
          @assists = assists
          @baron_kills = baron_kills
          @dragon_kills = dragon_kills
          @tower_kills = tower_kills
          @inhibitor_kills = inhibitor_kills
          @rift_herald_kills = rift_herald_kills
        end

        def to_h
          {
            team_id: team_id,
            win: win,
            kills: kills,
            deaths: deaths,
            assists: assists,
            baron_kills: baron_kills,
            dragon_kills: dragon_kills,
            tower_kills: tower_kills,
            inhibitor_kills: inhibitor_kills,
            rift_herald_kills: rift_herald_kills
          }
        end
      end
    end
  end
end
