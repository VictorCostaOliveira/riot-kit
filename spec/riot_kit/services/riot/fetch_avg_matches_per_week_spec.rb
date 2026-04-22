# frozen_string_literal: true

RSpec.describe RiotKit::Services::Riot::FetchAvgMatchesPerWeek do
  let(:client) { instance_double(RiotKit::Clients::Riot) }

  it 'calcula média arredondada por semana' do
    ids = Array.new(8) { |index| "M#{index}" }
    allow(client).to receive(:get_match_ids_by_puuid).and_return(HttpResponses.ok(ids))

    result = described_class.call(puuid: 'any', client: client)

    expect(result.value).to eq(2)
  end

  it 'retorna zero quando não há partidas' do
    allow(client).to receive(:get_match_ids_by_puuid).and_return(HttpResponses.ok([]))

    result = described_class.call(puuid: 'any', client: client)

    expect(result.value).to eq(0)
  end
end
