# frozen_string_literal: true

module RiotKit
  module Models
    module DataDragon
      class Champion
        attr_reader :id, :key, :name, :title

        def initialize(id:, key:, name:, title: '')
          @id = id
          @key = key
          @name = name
          @title = title
        end

        def self.from_hash(hash)
          symbolized = RiotKit::Util::Symbolize.deep_symbolize_keys(hash)
          new(
            id: symbolized[:id].to_i,
            key: symbolized[:key].to_s,
            name: symbolized[:name].to_s,
            title: symbolized[:title].to_s
          )
        end

        def to_h
          { id: id, key: key, name: name, title: title }
        end
      end
    end
  end
end
