<p align="center"><img src="https://raw.githubusercontent.com/vergecurrency/verge-ruby-client/master/ruby.png" alt="Verge Ruby Client"></p>

![Test and Lint](https://github.com/vergecurrency/verge-ruby-client/actions/workflows/ruby.yml/badge.svg)
![Live verged regtest](https://github.com/vergecurrency/verge-ruby-client/actions/workflows/verged-regtest.yml/badge.svg)

# Verge Ruby Client

Verge Ruby Client is a gem for making JSON-RPC calls to Verge Core (`verged`)
from Ruby.

## Requirements

- Ruby 3.2 or newer. Ruby 4.0.6 is the development and CI default.
- A running [Verge Core daemon](https://github.com/vergecurrency/verge).

By default, `verged` only accepts local RPC connections.

## Installation

Add the gem to your application:

```ruby
gem 'verge_client'
```

Then run `bundle install`.

## Configuration

Configure shared defaults:

```ruby
VERGEClient.configure do |config|
  config.host = '127.0.0.1'
  config.port = 20_102
  config.protocol = :http
  config.user = 'rpcuser'
  config.password = 'rpcpassword'
  config.open_timeout = 5
  config.read_timeout = 30
end
```

Options can also be passed to an individual client:

```ruby
client = VERGEClient.new(
  host: '127.0.0.1',
  port: 20_102,
  user: 'rpcuser',
  password: 'rpcpassword'
)
```

## Usage

Registered daemon commands are available as Ruby-style method calls:

```ruby
client = VERGEClient.new

if client.valid?
  info = client.get_blockchain_info
  address = client.get_new_address('receiving')
  balance = client.get_balance
end
```

Underscores are removed when translating Ruby method names to daemon command
names. For example, `get_blockchain_info` calls `getblockchaininfo`.

Commands can also be called explicitly:

```ruby
client.rpc_call('getblockchaininfo')
client.rpc_call(:get_blockchain_info)
```

Both forms enforce the same allowlist. Unknown or unregistered commands raise
`VERGEClient::InvalidMethodError`.

## Supported RPC Commands

The client allowlist is maintained in
[`lib/verge_client/methods.rb`](lib/verge_client/methods.rb). It contains 153
supported commands from the current
[`vergecurrency/verge` RPC reference](https://github.com/vergecurrency/verge/blob/master/RPC.md).
Commands absent from that allowlist, including every deprecated command, raise
`VERGEClient::InvalidMethodError`.

Every command below inherits the status shown in its section.

### Active

| Category | Commands |
| --- | --- |
| Control | `help`, `stop`, `uptime`, `getmemoryinfo`, `logging` |
| Blockchain | `getblockchaininfo`, `getchaintxstats`, `getblockstats`, `getbestblockhash`, `getblockcount`, `getblock`, `getblockhash`, `getblockheader`, `getchaintips`, `getdifficulty`, `getmempoolancestors`, `getmempooldescendants`, `getmempoolentry`, `getmempoolinfo`, `getrawmempool`, `gettxout`, `gettxoutsetinfo`, `pruneblockchain`, `savemempool`, `verifychain`, `preciousblock`, `gettxoutproof`, `verifytxoutproof` |
| Network | `getconnectioncount`, `ping`, `getpeerinfo`, `addnode`, `disconnectnode`, `getaddednodeinfo`, `getnettotals`, `getnetworkinfo`, `setban`, `listbanned`, `clearbanned`, `setnetworkactive`, `getnodeaddresses` |
| Mining and fees | `getnetworkhashps`, `getallnetworkhashps`, `getmininginfo`, `prioritisetransaction`, `getblocktemplate`, `decodeblock`, `reserializeblock`, `estimatesmartfee` |
| Raw transactions | `getrawtransaction`, `createrawtransaction`, `decoderawtransaction`, `decodescript`, `sendrawtransaction`, `combinerawtransaction`, `signrawtransaction`, `signrawtransactionwithkey`, `signrawtransactionwithwallet`, `testmempoolaccept`, `fundrawtransaction` |
| Utility | `validateaddress`, `createmultisig`, `verifymessage`, `signmessagewithprivkey`, `setalgo`, `debuginfo`, `getinfo` |
| Wallet | `abandontransaction`, `abortrescan`, `addmultisigaddress`, `backupwallet`, `bumpfee`, `createwallet`, `dumpprivkey`, `dumpwallet`, `encryptwallet`, `exportstealthaddress`, `getaddressinfo`, `getbalance`, `getnewaddress`, `getnewstealthaddress`, `getrawchangeaddress`, `getreceivedbyaddress`, `gettransaction`, `getunconfirmedbalance`, `getwalletinfo`, `importmulti`, `importprivkey`, `importwallet`, `importaddress`, `importprunedfunds`, `importpubkey`, `importstealthaddress`, `keypoolrefill`, `listaddressgroupings`, `listlockunspent`, `listreceivedbyaddress`, `listsinceblock`, `liststealthaddresses`, `listtransactions`, `listunspent`, `listwallets`, `loadwallet`, `lockunspent`, `sendmany`, `sendtoaddress`, `sendtostealthaddress`, `settxfee`, `signmessage`, `walletlock`, `walletpassphrasechange`, `walletpassphrase`, `removeprunedfunds`, `rescanblockchain`, `sethdseed`, `submitblock`, `generatetoaddress`, `generate` |
| Wallet labels | `getaddressesbylabel`, `getreceivedbylabel`, `listlabels`, `listreceivedbylabel`, `setlabel` |
| Secure messaging | `smsgenable`, `smsgdisable`, `smsgoptions`, `smsglocalkeys`, `smsgscanchain`, `smsgscanbuckets`, `smsginfo`, `flushsmgsdb`, `smsgaddaddress`, `smsgaddlocaladdress`, `smsgimportprivkey`, `smsggetpubkey`, `smsgsend`, `smsginbox`, `smsgoutbox`, `smsgbuckets`, `smsgview`, `smsg`, `smsgpurge` |

### Hidden or compatibility

These commands remain callable because upstream does not mark them deprecated,
but they are primarily intended for testing or advanced operator workflows:

`invalidateblock`, `reconsiderblock`, `waitfornewblock`, `waitforblock`,
`waitforblockheight`, `syncwithvalidationinterfacequeue`, `estimaterawfee`,
`setmocktime`, `echo`, `echojson`,
`resendwallettransactions`.

### Deprecated — not callable by this client

`sendfrom`, `smsgsendanon`, `addwitnessaddress`, `getaccountaddress`,
`getaccount`, `getaddressesbyaccount`, `getreceivedbyaccount`, `listaccounts`,
`listreceivedbyaccount`, `setaccount`, `move`.

`estimatefee` is also not callable. Although currently listed upstream as a
compatibility command, Verge Core v26.7 reports that it was removed and directs
clients to `estimatesmartfee`.

Use `verge-cli help <command>` for the result schema exposed by a particular
daemon build.

## Testing

Run the unit test and lint suites with:

```sh
bundle exec rake spec
bundle exec rubocop
```

The `Live verged regtest` GitHub Actions workflow downloads the official Verge
Core v26.7 Linux release, verifies its SHA-256 checksum, starts `verged` on a
fresh regtest chain, and runs `spec/live_regtest_spec.rb` against its live
JSON-RPC server. Its workflow summary displays the RPC responses returned
through this Ruby client. It also calls `help <command>` through the Ruby client
for every one of the 153 supported commands and publishes the daemon's first
response line for each. This verifies registration without executing dangerous
or state-changing commands merely for coverage.

To run the live spec locally, start a regtest daemon and set `LIVE_VERGED=1`.
The `VERGE_RPC_HOST`, `VERGE_RPC_PORT`, `VERGE_RPC_USER`, and
`VERGE_RPC_PASSWORD` environment variables override its defaults.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Add or update tests.
4. Run the test and lint suites.
5. Open a pull request.

## Why a Verge-specific client?

A Verge-specific allowlist follows Verge Core's registered RPC surface without
assuming that Bitcoin or Litecoin RPC compatibility is exact.
