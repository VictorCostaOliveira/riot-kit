# frozen_string_literal: true

module RiotKit
  module Models
    module DataDragon
      class Rune
        attr_reader :id, :name, :short_desc, :long_desc, :icon

        def initialize(id:, name:, short_desc: '', long_desc: '', icon: '')
          @id = id
          @name = name
          @short_desc = short_desc
          @long_desc = long_desc
          @icon = icon
        end

        def self.from_hash(hash)
          symbolized = RiotKit::Util::Symbolize.deep_symbolize_keys(hash)
          new(
            id: symbolized[:id].to_i,
            name: symbolized[:name].to_s,
            short_desc: symbolized[:short_desc].to_s,
            long_desc: symbolized[:long_desc].to_s,
            icon: symbolized[:icon].to_s
          )
        end

        def to_h
          { id: id, name: name, short_desc: short_desc, long_desc: long_desc, icon: icon }
        end
      end
    end
  end
end
