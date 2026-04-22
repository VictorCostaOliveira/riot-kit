# frozen_string_literal: true

RSpec.describe RiotKit::Config do
  it 'resolve routing e platform URLs' do
    config = described_class.new
    config.region = :americas
    config.platform = :br1
    expect(config.routing_base_url).to include('americas.api.riotgames.com')
    expect(config.platform_base_url).to include('br1.api.riotgames.com')
  end

  it 'levanta para região desconhecida' do
    config = described_class.new
    config.region = :invalid
    expect { config.routing_base_url }.to raise_error(RiotKit::Errors::InvalidParams)
  end
end
