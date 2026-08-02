# frozen_string_literal: true

require 'verge_client'

RSpec.describe VERGEClient do
  subject(:client) { described_class.new(user: 'alice', password: 'secret') }

  it 'delegates supported RPC methods to the transport client' do
    transport = client.instance_variable_get(:@client)
    allow(transport).to receive(:get_block_count).and_return(42)

    expect(client.get_block_count).to eq(42)
  end

  it 'reports supported RPC methods through respond_to?' do
    expect(client).to respond_to(:get_blockchain_info)
    expect(client).not_to respond_to(:not_a_real_method)
  end

  it 'uses global configuration as defaults' do
    original_port = described_class.configuration.port
    described_class.configure { |config| config.port = 18_334 }

    configured = described_class.new.instance_variable_get(:@client)
    expect(configured.options[:port]).to eq(18_334)
  ensure
    described_class.configuration.port = original_port
  end
end
