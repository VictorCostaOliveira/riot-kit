# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::FetchRankedData do
  let(:client) { instance_double(RiotKit::Clients::Riot) }

  it 'mapeia entradas para RankedEntry' do
    payload = {
      queueType: 'RANKED_SOLO_5x5',
      tier: 'GOLD',
      rank: 'I',
      leaguePoints: 40,
      wins: 10,
      losses: 8
    }
    allow(client).to receive(:get_ranked_entries_by_puuid)
      .with(puuid: 'p1')
      .and_return(HttpResponses.ok([payload]))

    result = described_class.call(puuid: 'p1', client: client)

    expect(result).to be_success
    expect(result.value.size).to eq(1)
    expect(result.value.first).to be_a(RiotKit::Models::Riot::RankedEntry)
    expect(result.value.first.tier).to eq('GOLD')
  end

  it 'falha sem puuid' do
    result = described_class.call(puuid: '', client: client)
    expect(result.error).to be_a(RiotKit::Errors::MissingPuuid)
  end

  it 'falha com RiotApiError quando ranked falha' do
    allow(client).to receive(:get_ranked_entries_by_puuid).and_return(HttpResponses.error(503))

    result = described_class.call(puuid: 'p1', client: client)
    expect(result.error).to be_a(RiotKit::Errors::RiotApiError)
  end
end
