# frozen_string_literal: true

require 'httparty'
require 'erb'
require 'socket'
require 'timeout'

require_relative '../util/symbolize'
require_relative 'response'

module RiotKit
  module Http
    NETWORK_ERRORS = [
      Net::ReadTimeout, Net::OpenTimeout, SocketError,
      Errno::ECONNREFUSED, Errno::ETIMEDOUT
    ].freeze

    class Client
      DEFAULT_HEADERS = { 'Content-Type' => 'application/json' }.freeze

      def initialize(base_url:, headers: {}, timeout: 30, logger: nil,
                     retry_attempts: 3, retry_base_delay: 0.5)
        @base_url = base_url.to_s.chomp('/')
        @headers = DEFAULT_HEADERS.merge(headers)
        @timeout = timeout
        @logger = logger
        @retry_attempts = retry_attempts
        @retry_base_delay = retry_base_delay
      end

      def get(path, query: nil, headers: nil)
        request(:get, path, query: query, headers: headers)
      end

      def post(path, body: nil, query: nil, headers: nil)
        request(:post, path, body: body, query: query, headers: headers)
      end

      private

      def request(method, path, query: nil, body: nil, headers: nil)
        merged_headers = @headers.merge(headers || {})
        uri = "#{@base_url}#{path}"
        attempts = 0

        loop do
          attempts += 1
          log("#{method.upcase} #{uri} query=#{query.inspect}")

          response = perform_http(method, uri, merged_headers, query, body)

          if retryable_status?(response.code.to_i) && attempts <= @retry_attempts
            sleep(@retry_base_delay * (2**(attempts - 1)))
            next
          end

          return build_response(response)
        rescue *NETWORK_ERRORS => e
          log("Network error: #{e.class} #{e.message}")
          return service_unavailable(e) if attempts >= @retry_attempts

          sleep(@retry_base_delay * (2**(attempts - 1)))
        rescue HTTParty::Error => e
          log("HTTParty error: #{e.class} #{e.message}")
          return service_unavailable(e) if attempts >= @retry_attempts

          sleep(@retry_base_delay * (2**(attempts - 1)))
        end
      end

      def perform_http(method, uri, headers, query, body)
        options = { headers: headers, timeout: @timeout }
        options[:query] = query if query
        options[:body] = body if body

        case method
        when :get
          HTTParty.get(uri, options)
        when :post
          HTTParty.post(uri, options)
        else
          raise ArgumentError, "Unsupported method #{method}"
        end
      end

      def retryable_status?(code)
        code == 429 || code.between?(500, 599)
      end

      def build_response(response)
        code = response.code.to_i
        parsed = response.parsed_response
        body = normalize_body(parsed)

        if code.between?(400, 599)
          Response.new(status: code, result: nil, error: body)
        else
          Response.new(status: code, result: body, error: nil)
        end
      end

      def normalize_body(parsed)
        case parsed
        when Hash
          Util::Symbolize.deep_symbolize_keys(parsed)
        when Array
          parsed.map do |item|
            item.is_a?(Hash) ? Util::Symbolize.deep_symbolize_keys(item) : item
          end
        else
          parsed
        end
      end

      def service_unavailable(error)
        Response.new(
          status: 503,
          result: nil,
          error: { message: 'Serviço indisponível', detail: error.message }
        )
      end

      def log(message)
        return unless @logger

        @logger.info("[RiotKit::Http::Client] #{message}")
      end
    end
  end
end
