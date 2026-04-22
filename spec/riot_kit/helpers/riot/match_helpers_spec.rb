# frozen_string_literal: true

RSpec.describe RiotKit::Helpers::Riot::MatchHelpers do
  let(:helper_class) do
    Class.new do
      include RiotKit::Helpers::Riot::MatchHelpers
    end
  end

  let(:helper) { helper_class.new }

  it 'calcula cs por minuto' do
    expect(helper.cs_per_minute(120, 600)).to eq(12.0)
  end

  it 'rotula fila' do
    expect(helper.queue_label_for(420)).to eq('Ranked Solo/Duo')
  end
end
