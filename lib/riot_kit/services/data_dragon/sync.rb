# frozen_string_literal: true

require 'fileutils'
require 'json'

require_relative '../../clients/data_dragon'
require_relative '../../registries/data_dragon'
require_relative '../../result'
require_relative '../../errors'

module RiotKit
  module Services
    module DataDragon
      class Sync
        DEFAULT_OUTPUT_DIR = File.expand_path('../../data/data_dragon', __dir__)

        def self.call(output_dir: DEFAULT_OUTPUT_DIR, locale: 'pt_BR', client: nil, config: RiotKit.config)
          new(
            output_dir: output_dir,
            locale: locale,
            client: client || Clients::DataDragon.new(config: config),
            config: config
          ).execute
        end

        def initialize(output_dir:, locale:, client:, config:)
          @output_dir = output_dir
          @locale = locale
          @client = client
          @config = config
        end

        def execute
          FileUtils.mkdir_p(@output_dir)

          version = fetch_latest_version
          File.write(File.join(@output_dir, 'version.txt'), "#{version}\n")

          write_items(version)
          write_champions(version)
          write_summoner_spells(version)
          write_runes(version)

          Registries::DataDragon.reload!

          RiotKit::Result.success(version)
        rescue Errors::Base => e
          RiotKit::Result.failure(e)
        rescue StandardError => e
          RiotKit::Result.failure(Errors::DataDragonError.new(e.message))
        end

        private

        def fetch_latest_version
          response = @client.get_versions
          raise Errors::DataDragonError, 'Versões indisponíveis' unless response.success?

          first = Array(response.result).first
          raise Errors::DataDragonError, 'Lista de versões vazia' unless first

          first.to_s
        end

        def write_items(version)
          response = @client.get_items(version: version, locale: @locale)
          raise Errors::DataDragonError, 'item.json indisponível' unless response.success?

          raw = response.result
          processed = {}
          (raw[:data] || {}).each do |item_id_str, info|
            processed[item_id_str.to_s] = {
              id: item_id_str.to_i,
              name: info[:name],
              plaintext: info[:plaintext].to_s,
              gold_total: info.dig(:gold, :total).to_i,
              image_full: info.dig(:image, :full).to_s,
              tags: info[:tags] || []
            }
          end
          write_json('items.json', processed)
        end

        def write_champions(version)
          response = @client.get_champions(version: version, locale: @locale)
          raise Errors::DataDragonError, 'champion.json indisponível' unless response.success?

          raw = response.result
          processed = {}
          (raw[:data] || {}).each_value do |info|
            key = info[:key].to_s
            processed[key] = {
              id: info[:key].to_i,
              key: key,
              name: info[:name].to_s,
              title: info[:title].to_s
            }
          end
          write_json('champions.json', processed)
        end

        def write_summoner_spells(version)
          response = @client.get_summoner_spells(version: version, locale: @locale)
          raise Errors::DataDragonError, 'summoner.json indisponível' unless response.success?

          raw = response.result
          processed = {}
          (raw[:data] || {}).each do |spell_id_str, info|
            processed[spell_id_str.to_s] = {
              id: spell_id_str.to_i,
              name: info[:name],
              description: info[:description].to_s,
              image_full: info.dig(:image, :full).to_s
            }
          end
          write_json('summoner_spells.json', processed)
        end

        def write_runes(version)
          response = @client.get_runes(version: version, locale: @locale)
          raise Errors::DataDragonError, 'runesReforged.json indisponível' unless response.success?

          raw = response.result
          processed = {}
          Array(raw).each do |tree|
            tree[:slots].each do |slot|
              slot[:runes].each do |rune|
                processed[rune[:id].to_s] = {
                  id: rune[:id],
                  name: rune[:name],
                  short_desc: rune[:shortDesc].to_s,
                  long_desc: rune[:longDesc].to_s,
                  icon: rune[:icon].to_s
                }
              end
            end
          end
          write_json('runes.json', processed)
        end

        def write_json(filename, payload)
          path = File.join(@output_dir, filename)
          File.write(path, JSON.pretty_generate(payload))
        end
      end
    end
  end
end
