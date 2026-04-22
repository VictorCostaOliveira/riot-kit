# frozen_string_literal: true

RSpec.describe RiotKit::Services::DataDragon::FetchSummonerSpells do
  around do |example|
    RiotKit::Registries::DataDragon.reload!
    example.run
    RiotKit::Registries::DataDragon.reload!
  end

  it 'retorna Flash' do
    spell = described_class.call(spell_id: 4).value!
    expect(spell.name).to eq('Flash')
  end
end
