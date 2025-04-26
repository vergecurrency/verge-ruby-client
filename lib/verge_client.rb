# frozen_string_literal: true

# Main client for interacting with the VERGE Daemon (verged) RPC.

require 'verge_client/version'
require 'verge_client/client'

# Main client for interacting with a VERGE RPC server.
class VERGEClient
  def initialize(options = {})
    super()
    @client = VERGEClient::Client.new(options)
  end

  # Delegate everything to the 'real' Client

  def method_missing(name, ...)
    @client.send(name, ...)
  end

  def respond_to_missing?(method_name, include_private = false)
    @client.respond_to?(method_name) || super
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
  # Configuration for the VERGE Client.
  
  class Configuration
    attr_accessor :host, :port, :protocol, :user, :password

    def initialize
      self.host = 'localhost'
      self.port = 20_102
      self.protocol = :http
      self.user = 'rpcuser'
      self.password = 'rpcpassword'
    end
  end
end
