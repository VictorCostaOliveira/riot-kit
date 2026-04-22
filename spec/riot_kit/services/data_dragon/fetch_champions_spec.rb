# frozen_string_literal: true

RSpec.describe RiotKit::Services::DataDragon::FetchChampions do
  around do |example|
    RiotKit::Registries::DataDragon.reload!
    example.run
    RiotKit::Registries::DataDragon.reload!
  end

  it 'resolve por id ou nome' do
    by_id = described_class.call(query: '266').value!
    expect(by_id.name).to eq('Aatrox')

    by_name = described_class.call(query: 'aatrox').value!
    expect(by_name.key).to eq('266')
  end
end
