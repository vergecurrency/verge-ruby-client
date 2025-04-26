# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'verge_client'
require 'verge_client/methods'
require 'errors/http_error'
require 'errors/rpc_error'
require 'errors/invalid_method_error'

class VERGEClient
  class Client
    attr_accessor :options

    def initialize(options = {})
      super()
      @options = get_defaults.merge(options)
    end

    def valid?
      post_body = { method: 'getinfo', id: Time.now.to_i }.to_json
      http_post_request(post_body).instance_of?(Net::HTTPOK)
    rescue StandardError
      false
    end

    def method_missing(name, *args)
      raise VERGEClient::InvalidMethodError, name unless VERGEClient::METHODS.include?(name.to_s)

      response = http_post_request(get_post_body(name, args))
      get_response_data(response)
    end
	
    def respond_to_missing?(method_name, include_private = false)
      @client.respond_to?(method_name) || super
    end

    def http_post_request(post_body)
      url = URI.parse "#{@options[:protocol]}://#{@options[:user]}:#{@options[:password]}@#{@options[:host]}:#{@options[:port]}/"

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Post.new(url.path)
      request.basic_auth url.user, url.password
      request.content_type = 'application/json'
      request.body = post_body

      response = http.request(request)

      return response if response.instance_of?(Net::HTTPOK) || response.instance_of?(Net::HTTPInternalServerError)

      raise VERGEClient::HTTPError, response
    end

    private

    def get_post_body(name, args)
      { method: de_ruby_style(name), params: args, id: Time.now.to_i }.to_json
    end

    def get_response_data(http_ok_response)
      resp = JSON.parse(http_ok_response.body)
      if resp['error'] && http_ok_response.instance_of?(Net::HTTPInternalServerError)
        raise VERGEClient::RPCError,
              resp['error']['message']
      end

      resp['result']
    end

    def de_ruby_style(method_name)
      method_name.to_s.tr('_', '').downcase.to_sym
    end

    def defaults
      VERGEClient.configuration.instance_variables.each.with_object({}) do |var, hash|
        hash[var.to_s.delete('@').to_sym] = VERGEClient.configuration.instance_variable_get(var)
      end
    end
  end
end
