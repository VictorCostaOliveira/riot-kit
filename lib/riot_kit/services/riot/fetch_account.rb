# frozen_string_literal: true

require_relative '../base'
require_relative '../../clients/riot'
require_relative '../../models/riot/account'

module RiotKit
  module Services
    module Riot
      class FetchAccount < RiotKit::Services::Base
        steps :parse_riot_id, :fetch_account

        def initialize(riot_id: nil, nickname: nil, client: nil, config: RiotKit.config)
          @riot_id_string = riot_id || nickname
          @client = client || Clients::Riot.new(config: config)
          @config = config
        end

        private

        def parse_riot_id
          raise Errors::InvalidParams, 'riot_id ou nickname obrigatório' if @riot_id_string.to_s.strip.empty?

          parts = @riot_id_string.to_s.split('#', 2)
          raise Errors::InvalidRiotId unless parts.size == 2

          @game_name, @tag_line = parts
        end

        def fetch_account
          response = @client.get_account_by_riot_id(game_name: @game_name, tag_line: @tag_line)
          raise Errors::AccountNotFound unless response.success?

          data = response.result
          @result = Models::Riot::Account.new(
            puuid: data[:puuid],
            game_name: @game_name,
            tag_line: @tag_line
          )
        end
      end
    end
  end
end
