module ApiQuery
  require 'net/http'
  require 'json'

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
end

