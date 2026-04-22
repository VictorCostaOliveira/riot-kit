# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::FetchAccount do
  let(:client) { instance_double(RiotKit::Clients::Riot) }

  it 'retorna Account quando a API responde 200' do
    allow(client).to receive(:get_account_by_riot_id)
      .with(game_name: 'Nick', tag_line: 'BR1')
      .and_return(HttpResponses.ok({ puuid: 'puuid-1' }))

    result = described_class.call(riot_id: 'Nick#BR1', client: client)

    expect(result).to be_success
    expect(result.value.puuid).to eq('puuid-1')
    expect(result.value.display_riot_id).to eq('Nick#BR1')
  end

  it 'aceita nickname no lugar de riot_id' do
    allow(client).to receive(:get_account_by_riot_id)
      .and_return(HttpResponses.ok({ puuid: 'x' }))

    result = described_class.call(nickname: 'A#B', client: client)

    expect(result.value.puuid).to eq('x')
  end

  it 'falha com InvalidRiotId sem #' do
    result = described_class.call(riot_id: 'invalid', client: client)
    expect(result).to be_failure
    expect(result.error).to be_a(RiotKit::Errors::InvalidRiotId)
  end

  it 'falha com AccountNotFound em 404' do
    allow(client).to receive(:get_account_by_riot_id).and_return(HttpResponses.error(404))

    result = described_class.call(riot_id: 'Nick#TAG', client: client)
    expect(result.error).to be_a(RiotKit::Errors::AccountNotFound)
  end
end
