require 'verge_client/version'
require 'verge_client/client'

class VERGEClient

  def initialize(options = {})
    @client = VERGEClient::Client.new(options)
  end

  # Delegate everything to the 'real' Client
  def method_missing(name, *args)
    @client.send(name, *args)
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :host, :port, :protocol, :user, :password

    def initialize
      self.host = 'localhost'
      self.port = 20102
      self.protocol = :http
      self.user = 'rpcuser'
      self.password = 'rpcpassword'
    end

  end

end
