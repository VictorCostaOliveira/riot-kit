# frozen_string_literal: true

require 'rails/generators/base'

module RiotKit
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc 'Copia config/initializers/riot_kit.rb com configuração base.'

      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        copy_file 'riot_kit.rb', 'config/initializers/riot_kit.rb'
      end
    end
  end
end
