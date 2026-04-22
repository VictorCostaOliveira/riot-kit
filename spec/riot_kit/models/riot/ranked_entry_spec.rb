# frozen_string_literal: true

RSpec.describe RiotKit::Models::Riot::RankedEntry do
  describe '.from_api' do
    it 'aceita chaves string e devolve to_h sem raw' do
      row = {
        'queueType' => 'RANKED_SOLO_5x5',
        'tier' => 'SILVER',
        'rank' => 'II',
        'leaguePoints' => 55,
        'wins' => 3,
        'losses' => 4,
        'summonerName' => 'X',
        'puuid' => 'p'
      }
      entry = described_class.from_api(row)

      expect(entry.queue_type).to eq('RANKED_SOLO_5x5')
      expect(entry.to_h[:tier]).to eq('SILVER')
      expect(entry.raw[:tier]).to eq('SILVER')
    end
  end
end
