# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class MatchCollection
        include Enumerable

        attr_reader :nickname, :filter, :puuid

        def initialize(nickname:, filter:, puuid:, client: nil, config: RiotKit.config)
          @nickname = nickname
          @filter = filter
          @puuid = puuid
          @client = client
          @config = config
        end

        def each(&)
          entries.each(&)
        end

        def entries
          ::RiotKit::Services::Riot::MatchHistory.call(
            nickname: nickname,
            filter: filter,
            puuid: puuid,
            client: @client,
            config: @config
          ).value!
        end

        def find_by_riot_id(match_id)
          ::RiotKit::Services::Riot::MatchDetail.call(
            match_id: match_id,
            puuid: puuid,
            client: @client,
            config: @config
          ).value!
        end
      end
    end
  end
end
