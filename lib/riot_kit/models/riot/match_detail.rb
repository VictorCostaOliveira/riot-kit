# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class MatchDetail
        attr_reader :match_id, :game_duration_seconds, :queue_id, :queue_label,
                    :game_creation, :teams, :participants

        def initialize(match_id:, game_duration_seconds:, queue_id:, queue_label:,
                       game_creation:, teams:, participants:)
          @match_id = match_id
          @game_duration_seconds = game_duration_seconds
          @queue_id = queue_id
          @queue_label = queue_label
          @game_creation = game_creation
          @teams = teams
          @participants = participants
        end

        def to_h
          {
            match_id: match_id,
            game_duration_seconds: game_duration_seconds,
            queue_id: queue_id,
            queue_label: queue_label,
            game_creation: game_creation,
            teams: teams.map(&:to_h),
            participants: participants.map(&:to_h)
          }
        end
      end
    end
  end
end
