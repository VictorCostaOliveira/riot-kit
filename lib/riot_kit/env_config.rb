# frozen_string_literal: true

module RiotKit
  # Applies configuration from ENV (and optionally Rails encrypted credentials). Optional helper;
  # call explicitly from your own initializer if you want env-driven setup.
  module EnvConfig
    ENV_API_KEY = 'RIOT_API_KEY'
    ENV_REGION = 'RIOT_REGION'
    ENV_PLATFORM = 'RIOT_PLATFORM'
    ENV_HTTP_TIMEOUT = 'RIOT_HTTP_TIMEOUT'
    ENV_RETRY_ATTEMPTS = 'RIOT_RETRY_ATTEMPTS'
    ENV_RETRY_BASE_DELAY = 'RIOT_RETRY_BASE_DELAY'

    class << self
      def apply(config)
        apply_api_key(config)
        apply_region(config)
        apply_platform(config)
        apply_http_timeout(config)
        apply_retry_attempts(config)
        apply_retry_base_delay(config)
        config
      end

      private

      def apply_api_key(config)
        key = resolve_api_key
        config.api_key = key unless key.nil?

        config
      end

      def resolve_api_key
        from_env = ENV[ENV_API_KEY]&.to_s&.strip
        return from_env unless from_env.nil? || from_env.empty?

        api_key_from_rails_credentials
      end

      def api_key_from_rails_credentials
        return nil unless defined?(Rails) && Rails.application.respond_to?(:credentials)

        creds = Rails.application.credentials
        return nil if creds.nil?

        if creds.respond_to?(:riot_api_key)
          value = creds.riot_api_key
          return value.to_s.strip unless value.nil? || value.to_s.strip.empty?
        end

        return creds[:riot_api_key].to_s.strip if creds.respond_to?(:[]) && creds[:riot_api_key]

        creds.dig(:riot, :api_key)&.to_s&.strip if creds.respond_to?(:dig)
      end

      def apply_region(config)
        raw = ENV[ENV_REGION]&.strip&.downcase
        return config if raw.nil? || raw.empty?

        sym = raw.to_sym
        unless Config::ROUTING_HOSTS.key?(sym)
          raise Errors::InvalidParams,
                "Invalid #{ENV_REGION}=#{ENV[ENV_REGION].inspect}; use one of: #{Config::ROUTING_HOSTS.keys.join(', ')}"
        end

        config.region = sym
        config
      end

      def apply_platform(config)
        raw = ENV[ENV_PLATFORM]&.strip&.downcase
        return config if raw.nil? || raw.empty?

        sym = raw.to_sym
        unless Config::PLATFORM_HOSTS.key?(sym)
          raise Errors::InvalidParams,
                "Invalid #{ENV_PLATFORM}=#{ENV[ENV_PLATFORM].inspect}; use one of: #{Config::PLATFORM_HOSTS.keys.join(', ')}"
        end

        config.platform = sym
        config
      end

      def apply_http_timeout(config)
        raw = ENV.fetch(ENV_HTTP_TIMEOUT, nil)
        return config if raw.nil? || raw.strip.empty?

        config.http_timeout = Integer(raw)
        config
      rescue ArgumentError
        raise Errors::InvalidParams, "#{ENV_HTTP_TIMEOUT} must be an integer seconds value; got #{raw.inspect}"
      end

      def apply_retry_attempts(config)
        raw = ENV.fetch(ENV_RETRY_ATTEMPTS, nil)
        return config if raw.nil? || raw.strip.empty?

        config.retry_attempts = Integer(raw)
        config
      rescue ArgumentError
        raise Errors::InvalidParams, "#{ENV_RETRY_ATTEMPTS} must be an integer; got #{raw.inspect}"
      end

      def apply_retry_base_delay(config)
        raw = ENV.fetch(ENV_RETRY_BASE_DELAY, nil)
        return config if raw.nil? || raw.strip.empty?

        config.retry_base_delay = Float(raw)
        config
      rescue ArgumentError
        raise Errors::InvalidParams, "#{ENV_RETRY_BASE_DELAY} must be a float seconds value; got #{raw.inspect}"
      end
    end
  end
end
