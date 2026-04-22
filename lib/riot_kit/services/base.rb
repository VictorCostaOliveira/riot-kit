# frozen_string_literal: true

require_relative '../result'

module RiotKit
  module Services
    class Base
      def self.call(**)
        new(**).call
      end

      def call
        process_steps
        Result.success(result_value)
      rescue Errors::Base => e
        Result.failure(e)
      end

      private

      def result_value
        @result
      end

      class << self
        def steps(*names)
          define_method(:process_steps) do
            names.each { |step_name| send(step_name) }
          end
        end
      end
    end
  end
end
