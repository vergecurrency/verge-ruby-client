# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'verge_client'
require 'verge_client/methods'
require 'errors/http_error'
require 'errors/rpc_error'
require 'errors/invalid_method_error'

# Main client for interacting with the VERGE Daemon (verged) RPC.
class VERGEClient
  # Handles low-level RPC HTTP communication with the VERGE server.
  class Client
    attr_reader :options

    # Initializes the VERGEClient::Client with options.
    def initialize(options = {})
      super()
      @options = defaults.merge(symbolize_keys(options))
    end

    # Checks the validity of the connection with an inexpensive RPC request.
    def valid?
      rpc_call(:getblockcount)
      true
    rescue StandardError
      false
    end

    # Calls an RPC method by its daemon name.
    def rpc_call(method, *params)
      response = http_post_request(get_post_body(method, params))
      get_response_data(response)
    end

    # Handles supported Ruby-style RPC method calls.
    def method_missing(name, *args, &block)
      return super if block

      raise VERGEClient::InvalidMethodError, name unless VERGEClient::METHODS.include?(name.to_s)

      rpc_call(name, *args)
    end

    def respond_to_missing?(method_name, include_private = false)
      VERGEClient::METHODS.include?(method_name.to_s) || super
    end

    # Makes an HTTP POST request to the VERGE Daemon with the given body.
    def http_post_request(post_body)
      url = build_url
      http = create_http_client(url)
      request = create_post_request(url, post_body)

      response = http.request(request)

      return response if response.is_a?(Net::HTTPSuccess) || rpc_error_response?(response)

      raise VERGEClient::HTTPError, response
    end

    private

    def build_url
      URI::Generic.build(
        scheme: @options[:protocol].to_s,
        host: @options[:host],
        port: Integer(@options[:port]),
        path: '/'
      )
    end

    def create_http_client(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      http.open_timeout = @options[:open_timeout]
      http.read_timeout = @options[:read_timeout]
      http
    end

    def create_post_request(url, post_body)
      request = Net::HTTP::Post.new(url.path)
      request.basic_auth @options[:user], @options[:password]
      request.content_type = 'application/json'
      request.body = post_body
      request
    end

    def rpc_error_response?(response)
      response.is_a?(Net::HTTPInternalServerError) && response['content-type']&.include?('application/json')
    end

    # Constructs the body for the RPC request based on the method name and arguments.
    def get_post_body(name, args)
      { jsonrpc: '1.0', method: de_ruby_style(name), params: args, id: object_id }.to_json
    end

    # Parses the response from the HTTP request and returns the result.
    def get_response_data(http_ok_response)
      resp = JSON.parse(http_ok_response.body)
      raise VERGEClient::RPCError, resp['error'] if resp['error']

      resp['result']
    rescue JSON::ParserError => e
      raise VERGEClient::HTTPError, http_ok_response, cause: e
    end

    # Converts a Ruby-style name (get_block_count) to a daemon name (getblockcount).
    def de_ruby_style(method_name)
      method_name.to_s.delete('_').downcase
    end

    # Fetches the default configuration for the VERGEClient.
    def defaults
      VERGEClient.configuration.instance_variables.each.with_object({}) do |var, hash|
        hash[var.to_s.delete('@').to_sym] = VERGEClient.configuration.instance_variable_get(var)
      end
    end

    def symbolize_keys(options)
      options.to_h.transform_keys(&:to_sym)
    end
  end
end
