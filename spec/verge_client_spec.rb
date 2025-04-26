# frozen_string_literal: true

require 'verge_client/client'

describe VERGEClient do
  def valid_client
    # make sure to replace these with the credentials from your own verged

    VERGEClient.new(user: 'vergerpcusername', password: 'vergerpcpassword')
  end

  it 'sets up and works with a valid client' do
    bad_client = VERGEClient.new
    bad_client.valid?.should eql(false)

    valid_client.valid?.should eql(true)
  end

  it 'calls client methods correctly' do
    addr = valid_client.get_new_address
    addr[0].should eql('D')
  end

  it 'configures itself properly' do
    VERGEClient.configure do |config|
      config.user = 'vergerpcusername'
      config.password = 'vergerpcpassword'
    end
    client = VERGEClient.new
    client.valid?.should eql(true)
  end

  it 'using results as args' do
    client = valid_client
    new_wallet_addr = client.get_new_address
    my_balance = client.get_balance(new_wallet_addr)
    my_balance.should eql(0.0)
  end
end
