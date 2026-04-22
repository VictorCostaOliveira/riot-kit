# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::MatchIds do
  let(:client) { instance_double(RiotKit::Clients::Riot) }
  let(:puuid) { 'user-puuid' }

  before do
    allow(client).to receive(:get_account_by_riot_id)
      .with(game_name: 'Nick', tag_line: 'TAG')
      .and_return(HttpResponses.ok({ puuid: puuid }))
  end

  it 'retorna lista de ids no filtro ranked' do
    allow(client).to receive(:get_match_ids_by_puuid)
      .with(puuid: puuid, queue: 420)
      .and_return(HttpResponses.ok(%w[BR1_1 BR1_2]))

    result = described_class.call(nickname: 'Nick#TAG', filter: 'ranked', client: client)

    expect(result.value).to eq(%w[BR1_1 BR1_2])
  end

  it 'usa filtro flex (queue 440)' do
    allow(client).to receive(:get_match_ids_by_puuid)
      .with(puuid: puuid, queue: 440)
      .and_return(HttpResponses.ok([]))

    result = described_class.call(nickname: 'Nick#TAG', filter: 'flex', client: client)

    expect(result.value).to eq([])
  end

  it 'falha em filtro inválido' do
    result = described_class.call(nickname: 'Nick#TAG', filter: 'nope', client: client)
    expect(result.error).to be_a(RiotKit::Errors::InvalidParams)
  end

  it 'retorna lista vazia quando match ids falham' do
    allow(client).to receive(:get_match_ids_by_puuid).and_return(HttpResponses.error(500))

    result = described_class.call(nickname: 'Nick#TAG', client: client)
    expect(result.value).to eq([])
  end
end
