# frozen_string_literal: true

RSpec.describe RiotKit::Result do
  it 'wraps success' do
    result = described_class.success(:ok)
    expect(result).to be_success
    expect(result.value).to eq(:ok)
    expect(result.value!).to eq(:ok)
  end

  it 'wraps failure' do
    error = RiotKit::Errors::InvalidParams.new
    result = described_class.failure(error)
    expect(result).to be_failure
    expect { result.value! }.to raise_error(RiotKit::Errors::InvalidParams)
  end
end
