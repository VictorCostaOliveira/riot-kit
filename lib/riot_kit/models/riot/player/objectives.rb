# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Objectives
          attr_reader :turret_kills, :turret_takedowns, :inhibitor_kills, :inhibitor_takedowns,
                      :baron_kills, :baron_takedowns, :dragon_kills, :dragon_takedowns,
                      :rift_herald_takedowns,
                      :damage_dealt_to_buildings, :damage_dealt_to_objectives, :damage_dealt_to_turrets,
                      :first_blood_kill, :first_tower_kill

          def initialize(**attrs)
            @turret_kills = attrs[:turret_kills]
            @turret_takedowns = attrs[:turret_takedowns]
            @inhibitor_kills = attrs[:inhibitor_kills]
            @inhibitor_takedowns = attrs[:inhibitor_takedowns]
            @baron_kills = attrs[:baron_kills]
            @baron_takedowns = attrs[:baron_takedowns]
            @dragon_kills = attrs[:dragon_kills]
            @dragon_takedowns = attrs[:dragon_takedowns]
            @rift_herald_takedowns = attrs[:rift_herald_takedowns]
            @damage_dealt_to_buildings = attrs[:damage_dealt_to_buildings]
            @damage_dealt_to_objectives = attrs[:damage_dealt_to_objectives]
            @damage_dealt_to_turrets = attrs[:damage_dealt_to_turrets]
            @first_blood_kill = attrs[:first_blood_kill]
            @first_tower_kill = attrs[:first_tower_kill]
          end

          def to_h
            {
              turret_kills: turret_kills,
              turret_takedowns: turret_takedowns,
              inhibitor_kills: inhibitor_kills,
              inhibitor_takedowns: inhibitor_takedowns,
              baron_kills: baron_kills,
              baron_takedowns: baron_takedowns,
              dragon_kills: dragon_kills,
              dragon_takedowns: dragon_takedowns,
              rift_herald_takedowns: rift_herald_takedowns,
              damage_dealt_to_buildings: damage_dealt_to_buildings,
              damage_dealt_to_objectives: damage_dealt_to_objectives,
              damage_dealt_to_turrets: damage_dealt_to_turrets,
              first_blood_kill: first_blood_kill,
              first_tower_kill: first_tower_kill
            }
          end
        end
      end
    end
  end
end
