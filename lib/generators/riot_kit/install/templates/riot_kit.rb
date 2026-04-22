# frozen_string_literal: true

# Documentação: https://github.com/VictorCostaOliveira/riot-kit (README)
#
# Variável de ambiente obrigatória para chamadas à Riot API:
#   RIOT_API_KEY

require 'riot_kit'

RiotKit.configure do |config|
  config.api_key = ENV.fetch('RIOT_API_KEY')
  config.region = :americas # :americas | :europe | :asia | :sea
  config.platform = :br1 # br1, na1, euw1, ...

  # Opcional:
  # config.http_timeout = 30
  # config.retry_attempts = 3
  # config.retry_base_delay = 0.5
  # config.logger = Rails.logger if defined?(Rails)
end
