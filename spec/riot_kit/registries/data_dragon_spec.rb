# frozen_string_literal: true

RSpec.describe RiotKit::Registries::DataDragon do
  around do |example|
    described_class.reload!
    example.run
    described_class.reload!
  end

  it 'carrega versão e registros com memoização' do
    registry = described_class.current
    expect(registry.version).to match(/\d+\.\d+\.\d+/)
    expect(registry.items['3078'][:name]).to eq('Infinity Edge')
    expect(registry.items.object_id).to eq(registry.items.object_id)
  end
end
