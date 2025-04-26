# frozen_string_literal: true

require 'verge_client/client'

describe VERGEClient do
  let(:valid_client) do
    # make sure to replace these with the credentials from your own verged
    VERGEClient.new(user: 'vergerpcusername', password: 'vergerpcpassword')
  end

  describe '#valid?' do
    it 'rejects invalid client' do
      bad_client = VERGEClient.new
      expect(bad_client.valid?).to eql(false)
    end

    it 'accepts valid client' do
      expect(valid_client.valid?).to eql(true)
    end
  end

  describe 'client method calls' do
    it 'calls client methods correctly' do
      addr = valid_client.get_new_address
      expect(addr[0]).to eql('D')
    end

    it 'using results as args' do
      new_wallet_addr = valid_client.get_new_address
      my_balance = valid_client.get_balance(new_wallet_addr)
      expect(my_balance).to eql(0.0)
    end
  end

  describe 'client configuration' do
    it 'configures itself properly' do
      VERGEClient.configure do |config|
        config.user = 'vergerpcusername'
        config.password = 'vergerpcpassword'
      end
      client = VERGEClient.new
      expect(client.valid?).to eql(true)
    end
  end
end
