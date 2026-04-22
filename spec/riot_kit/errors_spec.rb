# frozen_string_literal: true

RSpec.describe RiotKit::Errors do
  describe RiotKit::Errors::InvalidRiotId do
    it 'usa mensagem padrão' do
      expect(described_class.new.message).to include('Riot ID')
    end
  end

  describe RiotKit::Errors::AccountNotFound do
    it 'usa mensagem padrão' do
      expect(described_class.new.message).to eq(described_class::MESSAGE)
    end
  end

  describe RiotKit::Errors::MissingPuuid do
    it 'usa mensagem padrão' do
      expect(described_class.new.message).to eq(described_class::MESSAGE)
    end
  end

  describe RiotKit::Errors::DataDragonError do
    it 'aceita mensagem customizada' do
      expect(described_class.new('falhou').message).to eq('falhou')
    end
  end
end
