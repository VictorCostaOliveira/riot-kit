# frozen_string_literal: true

module RiotKit
  class Result
    attr_reader :value, :error

    def self.success(value)
      new(value: value, error: nil)
    end

    def self.failure(error)
      new(value: nil, error: error)
    end

    def initialize(value:, error:)
      @value = value
      @error = error
    end

    def success?
      error.nil?
    end

    def failure?
      !success?
    end

    def on_success
      yield(value) if success?

      self
    end

    def on_failure
      yield(error) if failure?

      self
    end

    def value!
      raise error if failure?

      value
    end
  end
end
