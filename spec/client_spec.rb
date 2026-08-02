# frozen_string_literal: true

require 'json'
require 'net/http'
require 'verge_client/client'

RSpec.describe VERGEClient::Client do
  subject(:client) do
    described_class.new(
      host: '127.0.0.1',
      port: 18_334,
      user: 'rpc-user',
      password: 'rpc-password'
    )
  end

  def response(klass, body, content_type: 'application/json')
    result = klass.new('1.1', klass == Net::HTTPOK ? '200' : '500', 'response')
    result.instance_variable_set(:@read, true)
    result.instance_variable_set(:@body, JSON.generate(body))
    result['content-type'] = content_type
    result
  end

  it 'merges supplied options with configured defaults' do
    expect(client.options).to include(
      host: '127.0.0.1',
      port: 18_334,
      protocol: :http,
      open_timeout: 5,
      read_timeout: 30
    )
  end

  it 'turns Ruby-style method names into daemon RPC calls' do
    allow(client).to receive(:http_post_request) do |body|
      request = JSON.parse(body)
      expect(request).to include('method' => 'getblockchaininfo', 'params' => [])
      response(Net::HTTPOK, 'result' => { 'chain' => 'regtest' }, 'error' => nil)
    end

    expect(client.get_blockchain_info).to eq('chain' => 'regtest')
  end

  it 'supports direct calls for daemon methods not yet in the convenience list' do
    allow(client).to receive(:http_post_request) do |body|
      expect(JSON.parse(body)['method']).to eq('futuremethod')
      response(Net::HTTPOK, 'result' => 'ok', 'error' => nil)
    end

    expect(client.rpc_call('futuremethod')).to eq('ok')
  end

  it 'raises an RPC error with the daemon code' do
    rpc_response = response(
      Net::HTTPInternalServerError,
      'result' => nil,
      'error' => { 'code' => -8, 'message' => 'Invalid parameter' }
    )
    allow(client).to receive(:http_post_request).and_return(rpc_response)

    error = begin
      client.get_block_hash(-1)
    rescue VERGEClient::RPCError => e
      e
    end

    expect(error.message).to eq('Invalid parameter')
    expect(error.code).to eq(-8)
  end

  it 'rejects unknown convenience methods locally' do
    expect { client.not_a_real_method }.to raise_error(
      VERGEClient::InvalidMethodError,
      'not_a_real_method is not a valid method.'
    )
  end

  it 'returns false from valid? when the daemon is unavailable' do
    allow(client).to receive(:rpc_call).and_raise(Errno::ECONNREFUSED)

    expect(client).not_to be_valid
  end
end
