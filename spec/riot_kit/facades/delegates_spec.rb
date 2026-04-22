# frozen_string_literal: true

RSpec.describe 'Facades Data Dragon' do
  around do |example|
    RiotKit::Registries::DataDragon.reload!
    example.run
    RiotKit::Registries::DataDragon.reload!
  end

  it 'Items.find e categorize' do
    item = RiotKit::Facades::Items.find(3078)
    expect(item.name).to eq('Infinity Edge')

    categories = RiotKit::Facades::Items.categorize([6655, 3006])
    expect(categories.keys).to include(:mythic, :boots)
  end

  it 'Champions.find resolve por nome' do
    champion = RiotKit::Facades::Champions.find('Aatrox')
    expect(champion.name.downcase).to include('aatrox')
  end

  it 'SummonerSpells e Runes' do
    spell = RiotKit::Facades::SummonerSpells.find(4)
    expect(spell.name).to eq('Flash')

    rune = RiotKit::Facades::Runes.find(8005)
    expect(rune.name).not_to be_empty
  end
end
