# frozen_string_literal: true

RSpec.describe RiotKit::Models::Riot::Account do
  it 'display_riot_id e to_h' do
    account = described_class.new(puuid: 'p', game_name: 'Name', tag_line: 'BR1')

    expect(account.display_riot_id).to eq('Name#BR1')
    expect(account.to_h).to eq(puuid: 'p', game_name: 'Name', tag_line: 'BR1')
  end
end
