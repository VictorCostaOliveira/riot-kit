# frozen_string_literal: true

require 'riot_kit'

namespace :data_dragon do
  desc 'Baixa dados do Data Dragon para lib/riot_kit/data/data_dragon'
  task :sync do
    result = RiotKit::Services::DataDragon::Sync.call
    raise result.error.message unless result.success?

    puts "Data Dragon sincronizado: #{result.value}"
  end

  desc 'Mostra versão snapshot commitada em lib/riot_kit/data/data_dragon/version.txt'
  task :version do
    puts RiotKit::Registries::DataDragon.current.version
  end
end
