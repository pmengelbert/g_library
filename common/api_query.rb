module ApiQuery
  require 'net/http'
  require 'json'
  require "resolv"

  private
    def get_response(url)
      @response ||= Net::HTTP.get_response(URI.parse(url))
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

    def connected_to_internet?
      dns_resolver = Resolv::DNS.new()
      begin
        dns_resolver.getaddress("symbolics.com")#the first domain name ever. Will probably not be removed ever.
        return true
      rescue Resolv::ResolvError => e
        return false
      end
    end
end

