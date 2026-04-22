# frozen_string_literal: true

require 'logger'

module RiotKit
  class Config
    ROUTING_HOSTS = {
      americas: 'https://americas.api.riotgames.com',
      europe: 'https://europe.api.riotgames.com',
      asia: 'https://asia.api.riotgames.com',
      sea: 'https://sea.api.riotgames.com'
    }.freeze

    PLATFORM_HOSTS = {
      br1: 'https://br1.api.riotgames.com',
      na1: 'https://na1.api.riotgames.com',
      la1: 'https://la1.api.riotgames.com',
      la2: 'https://la2.api.riotgames.com',
      oc1: 'https://oc1.api.riotgames.com',
      euw1: 'https://euw1.api.riotgames.com',
      eun1: 'https://eun1.api.riotgames.com',
      tr1: 'https://tr1.api.riotgames.com',
      ru: 'https://ru.api.riotgames.com',
      jp1: 'https://jp1.api.riotgames.com',
      kr: 'https://kr.api.riotgames.com',
      ph2: 'https://ph2.api.riotgames.com',
      sg2: 'https://sg2.api.riotgames.com',
      th2: 'https://th2.api.riotgames.com',
      tw2: 'https://tw2.api.riotgames.com',
      vn2: 'https://vn2.api.riotgames.com'
    }.freeze

    attr_accessor :api_key, :region, :platform, :http_timeout,
                  :logger, :retry_attempts, :retry_base_delay

    def initialize
      @api_key          = ENV.fetch('RIOT_API_KEY', nil)
      @region           = :americas
      @platform         = :br1
      @http_timeout     = 30
      @logger           = Logger.new($stdout)
      @retry_attempts   = 3
      @retry_base_delay = 0.5
    end

    def routing_base_url
      ROUTING_HOSTS.fetch(region.to_sym) do
        raise Errors::InvalidParams, "Unknown region: #{region.inspect}"
      end
    end

    def platform_base_url
      PLATFORM_HOSTS.fetch(platform.to_sym) do
        raise Errors::InvalidParams, "Unknown platform: #{platform.inspect}"
      end
    end
  end

  def self.configure
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end
end
