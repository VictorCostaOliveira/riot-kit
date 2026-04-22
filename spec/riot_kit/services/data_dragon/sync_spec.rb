# frozen_string_literal: true

RSpec.describe RiotKit::Services::DataDragon::Sync do
  let(:config) { RiotKit::Config.new.tap { |c| c.logger = nil } }

  it 'grava JSONs e retorna versão com sucesso' do
    client = instance_double(RiotKit::Clients::DataDragon)
    allow(client).to receive_messages(get_versions: HttpResponses.ok(['14.1.1']), get_items: HttpResponses.ok(
      data: {
        '3078' => {
          name: 'IE',
          plaintext: '',
          gold: { total: 3400 },
          image: { full: '3078.png' },
          tags: ['Damage']
        }
      }
    ), get_champions: HttpResponses.ok(
      data: {
        'Aatrox' => { key: '266', name: 'Aatrox', title: 'the Darkin Blade' }
      }
    ), get_summoner_spells: HttpResponses.ok(
      data: {
        '4' => { name: 'Flash', description: '', image: { full: 'SummonerFlash.png' } }
      }
    ), get_runes: HttpResponses.ok(
      [
        {
          slots: [
            {
              runes: [
                { id: 8005, name: 'Press', shortDesc: '', longDesc: '', icon: 'p.png' }
              ]
            }
          ]
        }
      ]
    ))

    Dir.mktmpdir do |directory|
      result = described_class.call(output_dir: directory, locale: 'pt_BR', client: client, config: config)

      expect(result).to be_success
      expect(result.value).to eq('14.1.1')
      expect(File.read(File.join(directory, 'version.txt')).strip).to eq('14.1.1')
      expect(File.exist?(File.join(directory, 'items.json'))).to be(true)
      expect(File.exist?(File.join(directory, 'champions.json'))).to be(true)
      expect(File.exist?(File.join(directory, 'summoner_spells.json'))).to be(true)
      expect(File.exist?(File.join(directory, 'runes.json'))).to be(true)
    end
  ensure
    RiotKit::Registries::DataDragon.reload!
  end

  it 'falha quando versões estão indisponíveis' do
    client = instance_double(RiotKit::Clients::DataDragon)
    allow(client).to receive(:get_versions).and_return(HttpResponses.error(503))

    Dir.mktmpdir do |directory|
      result = described_class.call(output_dir: directory, client: client, config: config)
      expect(result).to be_failure
      expect(result.error).to be_a(RiotKit::Errors::DataDragonError)
    end
  end
end
