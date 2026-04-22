# frozen_string_literal: true

RSpec.describe RiotKit::Models::Riot::MatchCollection do
  let(:client) { instance_double(RiotKit::Clients::Riot) }
  let(:puuid) { 'user-puuid' }
  let(:payload) { MatchPayloads.minimal_match(puuid: puuid) }

  it 'delega each para MatchHistory' do
    allow(client).to receive(:get_account_by_riot_id)
    allow(client).to receive(:get_match_ids_by_puuid).and_return(HttpResponses.ok(['BR1_123']))
    allow(client).to receive(:get_match).with(match_id: 'BR1_123').and_return(HttpResponses.ok(payload))

    collection = described_class.new(
      nickname: 'Nick#TAG',
      filter: 'ranked',
      puuid: puuid,
      client: client
    )

    ids = collection.map(&:match_id)
    expect(ids).to eq(['BR1_123'])
    expect(client).not_to have_received(:get_account_by_riot_id)
  end

  it 'find_by_riot_id usa MatchDetail' do
    allow(client).to receive(:get_match).with(match_id: 'BR1_123').and_return(HttpResponses.ok(payload))

    collection = described_class.new(
      nickname: 'Nick#TAG',
      filter: 'ranked',
      puuid: puuid,
      client: client
    )

    detail = collection.find_by_riot_id('BR1_123')
    expect(detail.match_id).to eq('BR1_123')
  end
end
