# frozen_string_literal: true

RSpec.describe RiotKit::Clients::DataDragon do
  let(:config) { RiotKit::Config.new.tap { |c| c.logger = nil } }

  describe "#get_items" do
    it "faz fallback para en_US quando pt_BR falha" do
      stub_request(:get, "https://ddragon.leagueoflegends.com/cdn/1.0.0/data/pt_BR/item.json")
        .to_return(status: 404, body: "", headers: {})
      stub_request(:get, "https://ddragon.leagueoflegends.com/cdn/1.0.0/data/en_US/item.json")
        .to_return(status: 200, body: '{"type":"item","version":"1","data":{}}', headers: { "Content-Type" => "application/json" })

      client = described_class.new(config: config)
      response = client.get_items(version: "1.0.0", locale: "pt_BR")

      expect(response).to be_success
      expect(response.result[:type]).to eq("item")
    end
  end
end
