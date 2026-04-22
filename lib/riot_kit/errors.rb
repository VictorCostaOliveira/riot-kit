# frozen_string_literal: true

module RiotKit
  module Errors
    class Base < StandardError
      def initialize(message = self.class::MESSAGE)
        super
      end
    end

    class InvalidRiotId < Base
      MESSAGE = 'Riot ID inválido (formato esperado: nome#tag)'
    end

    class AccountNotFound < Base
      MESSAGE = 'Conta Riot não encontrada'
    end

    class MatchNotFound < Base
      MESSAGE = 'Partida não encontrada'
    end

    class RiotApiError < Base
      MESSAGE = 'Erro ao consultar Riot API'
    end

    class DataDragonError < Base
      MESSAGE = 'Erro ao consultar Data Dragon'
    end

    class InvalidParams < Base
      MESSAGE = 'Parâmetros inválidos'
    end

    class MissingPuuid < Base
      MESSAGE = 'puuid obrigatório'
    end
  end
end
