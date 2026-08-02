# frozen_string_literal: true

require 'verge_client/methods'

RSpec.describe 'VERGEClient RPC methods' do
  subject(:methods) { VERGEClient::RPC_METHODS }

  it 'contains the complete unique supported command set' do
    expect(methods.length).to eq(153)
    expect(methods.uniq).to eq(methods)
  end

  it 'uses exact daemon command names' do
    expect(methods).to include(
      'getblockchaininfo',
      'signrawtransactionwithwallet',
      'smsgsend',
      'syncwithvalidationinterfacequeue'
    )
  end

  it 'does not contain deprecated RPC.md commands' do
    expect(methods).not_to include(
      'sendfrom',
      'smsgsendanon',
      'addwitnessaddress',
      'getaccountaddress',
      'getaccount',
      'getaddressesbyaccount',
      'getreceivedbyaccount',
      'listaccounts',
      'listreceivedbyaccount',
      'setaccount',
      'move',
      'estimatefee'
    )
  end
end
