
# frozen_string_literal: true

require 'net/http'
require 'verge_client/client'
require 'errors/http_error'
require 'errors/rpc_error'
require 'errors/invalid_method_error'

describe VERGEClient::Client do
  let(:valid_client) do
    # For local testing ensure you have verged running correctly and use your own username / password here
    VERGEClient::Client.new(user: 'vergerpcusername', password: 'rpcpassword')
  end

  let(:bad_client) { VERGEClient::Client.new(user: 'bad_username', password: 'bad_password') }
  let(:bad_host_client) { valid_client.tap { |c| c.options[:host] = 'not_localhost' } }
  let(:bad_port_client) { valid_client.tap { |c| c.options[:port] = 100 } }

  describe '#valid?' do
    it 'rejects bad credentials' do
      expect(bad_client.valid?).to eql(false)
    end

    it 'connects to the rpc server' do
      expect(valid_client.valid?).to eql(true)
    end
  end

  describe 'error handling' do
    it 'catches requests with bad credentials' do
      expect { bad_client.get_info }.to raise_error(VERGEClient::HTTPError)
    end

    it 'catches requests with bad service urls' do
      expect { bad_host_client.get_info }.to raise_error
      expect { bad_port_client.get_info }.to raise_error
    end

    it 'throws rpc_error when the params are bad' do
      expect { valid_client.get_account('bad_location') }.to raise_error(VERGEClient::RPCError)
    end

    it 'only allows listed methods' do
      expect { valid_client.not_a_real_method }.to raise_error(VERGEClient::InvalidMethodError)
    end
  end

  describe 'method names' do
    it 'works with ruby-style method names' do
      expect { valid_client.get_info }.not_to raise_error
      expect { valid_client.get_block_count }.not_to raise_error
    end
  end
end
