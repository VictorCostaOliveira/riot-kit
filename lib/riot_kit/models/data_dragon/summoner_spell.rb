# frozen_string_literal: true

module RiotKit
  module Models
    module DataDragon
      class SummonerSpell
        attr_reader :id, :name, :description, :image_full

        def initialize(id:, name:, description: '', image_full: '')
          @id = id
          @name = name
          @description = description
          @image_full = image_full
        end

        def self.from_hash(hash)
          symbolized = RiotKit::Util::Symbolize.deep_symbolize_keys(hash)
          new(
            id: symbolized[:id].to_i,
            name: symbolized[:name].to_s,
            description: symbolized[:description].to_s,
            image_full: symbolized[:image_full].to_s
          )
        end

        def to_h
          { id: id, name: name, description: description, image_full: image_full }
        end
      end
    end
  end
end
