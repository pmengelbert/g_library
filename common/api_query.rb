#!/usr/bin/env ruby


module Curl
  require 'net/http'
  require 'json'

#  private
    def get_response(url)
      Net::HTTP.get_response(URI.parse(url)).body
    end

    def get_response_hash(url)
      JSON.parse(get_response(url))
    end
end

