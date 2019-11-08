module ApiQuery
  require 'net/http'
  require 'json'
  require "resolv"

  private
    def get_response(url)
        Net::HTTP.get_response(URI.parse(url))
    end

    def get_response_hash(url)
      JSON.parse(get_response_body(url))
    end

    def get_response_code(url)
      get_response(url).code
    end

    def get_response_body(url)
      get_response(url).body
    end
    
    def correct_response_code?(response_code)
      return response_code == "200"
    end

    def connected_to_internet?(address = "google.com")
      dns_resolver = Resolv::DNS.new()
      begin
        dns_resolver.getaddress(address)
        return true
      rescue Resolv::ResolvError
        return false
      end
    end
end

