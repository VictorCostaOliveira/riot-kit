# frozen_string_literal: true

RSpec.describe RiotKit::EnvConfig do
  let(:config) { RiotKit::Config.new }

  before do
    %w[RIOT_API_KEY RIOT_REGION RIOT_PLATFORM RIOT_HTTP_TIMEOUT RIOT_RETRY_ATTEMPTS RIOT_RETRY_BASE_DELAY].each do |key|
      ENV.delete(key)
    end
  end

  it 'applies RIOT_API_KEY' do
    ENV['RIOT_API_KEY'] = '  k1  '

    described_class.apply(config)

    expect(config.api_key).to eq('k1')
  end

  it 'applies RIOT_REGION' do
    ENV['RIOT_REGION'] = 'europe'

    described_class.apply(config)

    expect(config.region).to eq(:europe)
  end

  it 'applies RIOT_PLATFORM' do
    ENV['RIOT_PLATFORM'] = 'na1'

    described_class.apply(config)

    expect(config.platform).to eq(:na1)
  end

  it 'rejeita região inválida' do
    ENV['RIOT_REGION'] = 'narnia'

    expect { described_class.apply(config) }.to raise_error(RiotKit::Errors::InvalidParams, /Invalid RIOT_REGION/)
  end

  it 'applies timeouts numéricos' do
    ENV['RIOT_HTTP_TIMEOUT'] = '45'
    ENV['RIOT_RETRY_ATTEMPTS'] = '5'
    ENV['RIOT_RETRY_BASE_DELAY'] = '1.25'

    described_class.apply(config)

    expect(config.http_timeout).to eq(45)
    expect(config.retry_attempts).to eq(5)
    expect(config.retry_base_delay).to eq(1.25)
  end
end
