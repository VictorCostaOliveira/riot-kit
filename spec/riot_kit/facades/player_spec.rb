# frozen_string_literal: true

RSpec.describe RiotKit::Facades::Player do
  let(:config) do
    RiotKit::Config.new.tap do |configuration|
      configuration.logger = nil
      configuration.api_key = 'fake-key'
      configuration.region = :americas
      configuration.platform = :br1
    end
  end
  let(:riot_client) { instance_double(RiotKit::Clients::Riot) }

  before do
    allow(RiotKit::Clients::Riot).to receive(:new).with(config: config).and_return(riot_client)
  end

  describe '.find' do
    it 'expõe puuid e delega serviços com o mesmo client' do
      allow(riot_client).to receive(:get_ranked_entries_by_puuid)
        .with(puuid: 'puuid-1')
        .and_return(HttpResponses.ok([]))
      allow(riot_client).to receive_messages(get_account_by_riot_id: HttpResponses.ok({ puuid: 'puuid-1' }), get_match_ids_by_puuid: HttpResponses.ok([]))

      player = described_class.find('Nick#TAG', config: config)

      expect(player.display_riot_id).to eq('Nick#TAG')
      expect(player.ranked).to eq([])
      expect(player.avg_matches_per_week).to eq(0)
    end
  end

  describe '#matches' do
    before do
      allow(riot_client).to receive_messages(get_account_by_riot_id: HttpResponses.ok({ puuid: 'puuid-1' }), get_match_ids_by_puuid: HttpResponses.ok(['BR1_1']))
      allow(riot_client).to receive(:get_match).with(match_id: 'BR1_1').and_return(
        HttpResponses.ok(MatchPayloads.minimal_match(puuid: 'puuid-1', match_id: 'BR1_1'))
      )
      allow(RiotKit::Models::Riot::LazyMatchEntries).to receive(:build).and_call_original
    end

    it 'memoiza por filtro: não reconstrói LazyMatchEntries (ex.: matches.first repetido)' do
      player = described_class.find('Nick#TAG', config: config)

      player.matches
      player.matches
      player.matches.first

      expect(RiotKit::Models::Riot::LazyMatchEntries).to have_received(:build).once
      expect(riot_client).to have_received(:get_account_by_riot_id).once
    end

    it 'usa cache separado por filtro' do
      player = described_class.find('Nick#TAG', config: config)

      player.matches(:ranked)
      player.matches(:flex)

      expect(RiotKit::Models::Riot::LazyMatchEntries).to have_received(:build).twice
    end

    it 'reload: true força nova busca' do
      player = described_class.find('Nick#TAG', config: config)

      player.matches
      player.matches(reload: true)

      expect(RiotKit::Models::Riot::LazyMatchEntries).to have_received(:build).twice
    end

    it '.first só dispara um get_match mesmo com vários ids na lista' do
      allow(riot_client).to receive(:get_match_ids_by_puuid).and_return(
        HttpResponses.ok(%w[BR1_A BR1_B BR1_C])
      )
      allow(riot_client).to receive(:get_match).with(match_id: 'BR1_A').and_return(
        HttpResponses.ok(MatchPayloads.minimal_match(puuid: 'puuid-1', match_id: 'BR1_A'))
      )

      player = described_class.find('Nick#TAG', config: config)
      entry = player.matches.first

      expect(entry.match_id).to eq('BR1_A')
      expect(riot_client).to have_received(:get_match).once
    end
  end

  describe '#match' do
    it 'retorna MatchDetail' do
      allow(riot_client).to receive(:get_account_by_riot_id)
        .and_return(HttpResponses.ok({ puuid: 'puuid-1' }))
      allow(riot_client).to receive(:get_match).with(match_id: 'BR1_1').and_return(
        HttpResponses.ok(MatchPayloads.minimal_match(puuid: 'puuid-1', match_id: 'BR1_1'))
      )

      player = described_class.find('Nick#TAG', config: config)
      detail = player.match('BR1_1')

      expect(detail.match_id).to eq('BR1_1')
    end
  end
end
