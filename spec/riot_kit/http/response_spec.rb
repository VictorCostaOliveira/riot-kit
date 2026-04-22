# frozen_string_literal: true

RSpec.describe RiotKit::Http::Response do
  it 'success? para 2xx' do
    expect(described_class.new(status: 200)).to be_success
    expect(described_class.new(status: 204)).to be_success
  end

  it 'não é success para 4xx/5xx' do
    expect(described_class.new(status: 404)).not_to be_success
    expect(described_class.new(status: 503)).not_to be_success
  end

  it 'normaliza status para inteiro' do
    expect(described_class.new(status: '201').status).to eq(201)
  end
end
