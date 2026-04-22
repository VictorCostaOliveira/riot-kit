# frozen_string_literal: true

module RiotKit
  module Util
    module Symbolize
      module_function

      def deep_symbolize_keys(object)
        case object
        when Hash
          object.each_with_object({}) do |(key, value), result|
            symbol_key = key.respond_to?(:to_sym) ? key.to_sym : key
            result[symbol_key] = deep_symbolize_keys(value)
          end
        when Array
          object.map { |element| deep_symbolize_keys(element) }
        else
          object
        end
      end
    end
  end
end
