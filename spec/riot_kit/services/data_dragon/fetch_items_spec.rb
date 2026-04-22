# frozen_string_literal: true

RSpec.describe RiotKit::Services::DataDragon::FetchItems do
  around do |example|
    RiotKit::Registries::DataDragon.reload!
    example.run
    RiotKit::Registries::DataDragon.reload!
  end

  it 'retorna Item por id' do
    result = described_class.call(item_id: 3078)
    expect(result).to be_success
    expect(result.value.name).to eq('Infinity Edge')
  end

  it 'categoriza itens' do
    categories = described_class.categorize([6655, 3006, 1036])
    expect(categories[:mythic]).to include(6655)
    expect(categories[:boots]).to include(3006)
    expect(categories[:legendary]).to include(1036)
  end
end
