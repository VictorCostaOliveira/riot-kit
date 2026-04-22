# frozen_string_literal: true

RSpec.describe RiotKit::Clients::Riot do
  let(:config) do
    RiotKit::Config.new.tap do |c|
      c.logger = nil
      c.region = :americas
      c.platform = :br1
      c.api_key = 'fake-key'
    end
  end

  describe '#get_account_by_riot_id' do
    it 'codifica nome/tag na URL e envia X-Riot-Token' do
      stub_request(:get, %r{americas\.api\.riotgames\.com/riot/account/v1/accounts/by-riot-id/})
        .with(
          headers: { 'X-Riot-Token' => 'fake-key' }
        )
        .to_return(status: 200, body: '{"puuid":"abc"}', headers: { 'Content-Type' => 'application/json' })

      client = described_class.new(config: config)
      response = client.get_account_by_riot_id(game_name: 'Name Space', tag_line: 'TAG')

      expect(response).to be_success
      expect(response.result[:puuid]).to eq('abc')
    end
  end

  it 'levanta quando api_key está vazio' do
    bad = RiotKit::Config.new.tap do |c|
      c.logger = nil
      c.region = :americas
      c.platform = :br1
      c.api_key = nil
    end
    client = described_class.new(config: bad)
    expect { client.get_account_by_riot_id(game_name: 'A', tag_line: 'B') }.to raise_error(RiotKit::Errors::InvalidParams)
  end
end
