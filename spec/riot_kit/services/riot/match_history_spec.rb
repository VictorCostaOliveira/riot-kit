# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::MatchHistory do
  let(:puuid) { 'user-puuid' }
  let(:payload) { MatchPayloads.minimal_match(puuid: puuid) }
  let(:client) { instance_double(RiotKit::Clients::Riot) }

  it 'monta MatchEntry a partir de ids injetados' do
    allow(client).to receive(:get_account_by_riot_id)
    allow(client).to receive(:get_match).with(match_id: 'BR1_123').and_return(HttpResponses.ok(payload))

    result = described_class.call(
      nickname: 'Nick#TAG',
      filter: 'ranked',
      match_ids: ['BR1_123'],
      puuid: puuid,
      client: client
    )

    expect(result).to be_success
    expect(result.value.size).to eq(1)
    entry = result.value.first
    expect(entry.match_id).to eq('BR1_123')
    expect(entry.champion_name).to eq('Annie')
    expect(entry.puuid).to eq(puuid)
    expect(entry.queue_label).to eq('Ranked Solo/Duo')
    expect(client).not_to have_received(:get_account_by_riot_id)
  end

  it 'ignora partida quando get_match falha' do
    allow(client).to receive(:get_account_by_riot_id)
      .with(game_name: 'Nick', tag_line: 'TAG')
      .and_return(HttpResponses.ok({ puuid: puuid }))
    allow(client).to receive_messages(get_match: HttpResponses.error(500), get_match_ids_by_puuid: HttpResponses.ok(['BR1_bad']))

    result = described_class.call(nickname: 'Nick#TAG', client: client)

    expect(result.value).to eq([])
  end

  it 'com limit 1 só chama get_match uma vez' do
    allow(client).to receive(:get_account_by_riot_id)
      .with(game_name: 'Nick', tag_line: 'TAG')
      .and_return(HttpResponses.ok({ puuid: puuid }))
    allow(client).to receive(:get_match_ids_by_puuid).and_return(HttpResponses.ok(%w[ID1 ID2 ID3]))
    allow(client).to receive(:get_match).with(match_id: 'ID1').and_return(
      HttpResponses.ok(MatchPayloads.minimal_match(puuid: puuid, match_id: 'ID1'))
    )

    result = described_class.call(nickname: 'Nick#TAG', client: client, limit: 1)

    expect(result.value.size).to eq(1)
    expect(client).to have_received(:get_match).once
  end
end
