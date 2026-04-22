# frozen_string_literal: true

RSpec.describe RiotKit::Services::DataDragon::FetchRunes do
  around do |example|
    RiotKit::Registries::DataDragon.reload!
    example.run
    RiotKit::Registries::DataDragon.reload!
  end

  it 'retorna runa por id' do
    rune = described_class.call(rune_id: 8005).value!
    expect(rune.name).to eq('Press the Attack')
  end
end
