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
    attr_accessor :options

    # Initializes the VERGEClient::Client with options.
    def initialize(options = {})
      super()
      @options = get_defaults.merge(options)
    end

    # Checks the validity of the connection by sending a 'getinfo' RPC request.
    def valid?
      post_body = { method: 'getinfo', id: Time.now.to_i }.to_json
      http_post_request(post_body).instance_of?(Net::HTTPOK)
    rescue StandardError
      false
    end

    # Handles undefined method calls by checking if the method is valid.
    def method_missing(name, *args)
      raise VERGEClient::InvalidMethodError, name unless VERGEClient::METHODS.include?(name.to_s)

      response = http_post_request(get_post_body(name, args))
      get_response_data(response)
    end

    # Checks if a method is defined or responds to the given method name.
    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    # Makes an HTTP POST request to the VERGE Daemon with the given body.
    def http_post_request(post_body)
      url = build_url
      http = create_http_client(url)
      request = create_post_request(url, post_body)

      response = http.request(request)

      return response if valid_response?(response)

      raise VERGEClient::HTTPError, response
    end

    private

    def build_url
      URI.parse "#{@options[:protocol]}://#{@options[:user]}:#{@options[:password]}@" \
                "#{@options[:host]}:#{@options[:port]}/"
    end

    def create_http_client(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      http
    end

    def create_post_request(url, post_body)
      request = Net::HTTP::Post.new(url.path)
      request.basic_auth url.user, url.password
      request.content_type = 'application/json'
      request.body = post_body
      request
    end

    def valid_response?(response)
      response.instance_of?(Net::HTTPOK) || response.instance_of?(Net::HTTPInternalServerError)
    end

    # Constructs the body for the RPC request based on the method name and arguments.
    def get_post_body(name, args)
      { method: de_ruby_style(name), params: args, id: Time.now.to_i }.to_json
    end

    # Parses the response from the HTTP request and returns the result.
    def get_response_data(http_ok_response)
      resp = JSON.parse(http_ok_response.body)
      if resp['error'] && http_ok_response.instance_of?(Net::HTTPInternalServerError)
        raise VERGEClient::RPCError, resp['error']['message']
      end

      resp['result']
    end

    # Converts a method name from Ruby style (snake_case) to API style (camelCase).
    def de_ruby_style(method_name)
      method_name.to_s.tr('_', '').downcase.to_sym
    end

    # Fetches the default configuration for the VERGEClient.
    def defaults
      VERGEClient.configuration.instance_variables.each.with_object({}) do |var, hash|
        hash[var.to_s.delete('@').to_sym] = VERGEClient.configuration.instance_variable_get(var)
      end
    end
  end
end
