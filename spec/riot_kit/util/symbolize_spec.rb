# frozen_string_literal: true

RSpec.describe RiotKit::Util::Symbolize do
  describe '.deep_symbolize_keys' do
    it 'simboliza hash aninhado' do
      input = { 'a' => { 'b' => [{ 'c' => 1 }] } }
      out = described_class.deep_symbolize_keys(input)
      expect(out).to eq(a: { b: [{ c: 1 }] })
    end

    it 'preserva valores não-hash' do
      expect(described_class.deep_symbolize_keys([1, 'x', nil])).to eq([1, 'x', nil])
    end

    it 'preserva chaves não convertíveis' do
      expect(described_class.deep_symbolize_keys({ 1 => 'v' })).to eq({ 1 => 'v' })
    end
  end
end
