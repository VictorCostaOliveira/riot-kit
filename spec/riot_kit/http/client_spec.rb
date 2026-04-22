# frozen_string_literal: true

RSpec.describe RiotKit::Http::Client do
  let(:base_url) { 'https://httpbin.test' }

  describe '#get' do
    it 'parseia JSON e simboliza chaves' do
      stub_request(:get, "#{base_url}/foo")
        .to_return(status: 200, body: '{"hello":{"world":1}}', headers: { 'Content-Type' => 'application/json' })

      client = described_class.new(base_url: base_url)
      response = client.get('/foo')

      expect(response).to be_success
      expect(response.result).to eq(hello: { world: 1 })
    end

    it 'retorna erro para 404' do
      stub_request(:get, "#{base_url}/missing")
        .to_return(status: 404, body: '{"status":404}', headers: { 'Content-Type' => 'application/json' })

      client = described_class.new(base_url: base_url)
      response = client.get('/missing')

      expect(response).not_to be_success
      expect(response.status).to eq(404)
      expect(response.error).to eq(status: 404)
    end

    it 'retenta em 500 e eventualmente devolve erro' do
      stub_request(:get, "#{base_url}/flaky")
        .to_return(
          { status: 500, body: '{}', headers: { 'Content-Type' => 'application/json' } },
          { status: 500, body: '{}', headers: { 'Content-Type' => 'application/json' } },
          { status: 500, body: '{}', headers: { 'Content-Type' => 'application/json' } },
          { status: 500, body: '{}', headers: { 'Content-Type' => 'application/json' } }
        )

      client = described_class.new(base_url: base_url, retry_attempts: 3, retry_base_delay: 0)
      response = client.get('/flaky')

      expect(response.status).to eq(500)
      expect(response).not_to be_success
    end

    it 'retenta em 429 e obtém sucesso' do
      stub_request(:get, "#{base_url}/rate")
        .to_return(
          { status: 429, body: '{}', headers: { 'Content-Type' => 'application/json' } },
          { status: 200, body: '{"ok":true}', headers: { 'Content-Type' => 'application/json' } }
        )

      client = described_class.new(base_url: base_url, retry_attempts: 3, retry_base_delay: 0)
      response = client.get('/rate')

      expect(response).to be_success
      expect(response.result).to eq(ok: true)
    end
  end

  describe '#post' do
    it 'envia body' do
      stub_request(:post, "#{base_url}/post")
        .with(body: '{}')
        .to_return(status: 201, body: '{"created":true}', headers: { 'Content-Type' => 'application/json' })

      client = described_class.new(base_url: base_url)
      response = client.post('/post', body: '{}')

      expect(response).to be_success
      expect(response.result).to eq(created: true)
    end
  end
end
