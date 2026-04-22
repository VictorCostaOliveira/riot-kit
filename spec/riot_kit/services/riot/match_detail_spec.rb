# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::MatchDetail do
  let(:puuid) { 'user-puuid' }
  let(:payload) { MatchPayloads.minimal_match(puuid: puuid) }

  it 'usa raw_data sem chamar o client' do
    client = instance_double(RiotKit::Clients::Riot)
    allow(client).to receive(:get_match)
    result = described_class.call(match_id: 'BR1_123', puuid: puuid, raw_data: payload, client: client)

    expect(result).to be_success
    expect(result.value.match_id).to eq('BR1_123')
    expect(result.value.queue_label).to eq('Ranked Solo/Duo')
    expect(client).not_to have_received(:get_match)
  end

  it 'busca partida quando raw_data é nil' do
    client = instance_double(RiotKit::Clients::Riot)
    allow(client).to receive(:get_match).with(match_id: 'BR1_123').and_return(HttpResponses.ok(payload))

    result = described_class.call(match_id: 'BR1_123', puuid: puuid, client: client)

    expect(result).to be_success
    expect(result.value.participants.map(&:current_user).count(true)).to eq(1)
  end

  it 'falha quando partida não existe' do
    client = instance_double(RiotKit::Clients::Riot)
    allow(client).to receive(:get_match).and_return(HttpResponses.error(404))

    result = described_class.call(match_id: 'x', puuid: puuid, client: client)

    expect(result.error).to be_a(RiotKit::Errors::MatchNotFound)
  end
end
