# frozen_string_literal: true

module RiotKit
  module Models
    module DataDragon
      class Item
        attr_reader :id, :name, :plaintext, :gold_total, :image_full, :tags

        def initialize(id:, name:, plaintext: '', gold_total: 0, image_full: '', tags: [])
          @id = id
          @name = name
          @plaintext = plaintext
          @gold_total = gold_total
          @image_full = image_full
          @tags = tags
        end

        def self.from_hash(hash)
          symbolized = RiotKit::Util::Symbolize.deep_symbolize_keys(hash)
          new(
            id: symbolized[:id],
            name: symbolized[:name],
            plaintext: symbolized[:plaintext].to_s,
            gold_total: symbolized[:gold_total].to_i,
            image_full: symbolized[:image_full].to_s,
            tags: Array(symbolized[:tags])
          )
        end

        def to_h
          {
            id: id,
            name: name,
            plaintext: plaintext,
            gold_total: gold_total,
            image_full: image_full,
            tags: tags
          }
        end
      end
    end
  end
end
