# frozen_string_literal: true

module RiotKit
  module Http
    class Response
      attr_reader :status, :result, :error

      def initialize(status:, result: nil, error: nil)
        @status = status.to_i
        @result = result
        @error = error
      end

      def success?
        status.between?(200, 299)
      end
    end
  end
end
