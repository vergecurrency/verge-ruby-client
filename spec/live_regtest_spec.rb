# frozen_string_literal: true

require 'json'
require 'verge_client'

RSpec.describe 'Verge Core live regtest', :live do
  def report_rpc(method, result)
    puts
    puts "Ruby client RPC: #{method}"
    puts JSON.pretty_generate(result)
  end

  let(:client) do
    VERGEClient.new(
      host: ENV.fetch('VERGE_RPC_HOST', '127.0.0.1'),
      port: Integer(ENV.fetch('VERGE_RPC_PORT', '18334')),
      user: ENV.fetch('VERGE_RPC_USER', 'verge-ruby'),
      password: ENV.fetch('VERGE_RPC_PASSWORD', 'verge-ruby-regtest')
    )
  end

  it 'connects to the real daemon' do
    connected = client.valid?
    report_rpc('valid?', connected)

    expect(connected).to be(true)
  end

  it 'confirms that the daemon is on an empty regtest chain' do
    info = client.get_blockchain_info
    block_count = client.get_block_count
    best_block_hash = client.get_best_block_hash

    report_rpc('getblockchaininfo', info)
    report_rpc('getblockcount', block_count)
    report_rpc('getbestblockhash', best_block_hash)

    expect(info.fetch('chain')).to eq('regtest')
    expect(block_count).to eq(0)
    expect(best_block_hash).to eq(
      '65b4e101cacf3e1e4f3a9237e3a74ffd1186e595d8b78fa8ea22c21ef5bf9347'
    )
  end

  it 'exercises a wallet RPC against the live daemon' do
    address = client.get_new_address('ruby-client-live-test')
    balance = client.get_balance

    report_rpc('getnewaddress', address)
    report_rpc('getbalance', balance)

    expect(address).to be_a(String)
    expect(address).not_to be_empty
    expect(balance).to be_a(Numeric)
  end

  it 'confirms every supported RPC is registered by the live daemon' do
    registrations = VERGEClient::RPC_METHODS.to_h do |method|
      help_response = client.help(method)
      [method, help_response.lines.first.to_s.strip]
    end

    report_rpc('help <each supported command>', registrations)

    expect(registrations.length).to eq(153)
    unknown_commands = registrations.select do |_method, response|
      response.start_with?('help: unknown command:')
    end
    expect(unknown_commands).to be_empty
  end
end
