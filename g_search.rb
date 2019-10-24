require_relative 'common/api_query'
require_relative 'common/google_api_key'

class Search
  include ApiQuery

  attr_reader :hash

  def initialize(args = {})
    @raw_args = args
    url_arg_list = make_url_arg_list

    @hash = get_response_hash(BASE_API_URL + url_arg_list)
  end

  private 
    def make_url_arg_list
      @raw_args.map do |k, v|
        "&%s=%s" % [k.to_s, v]
      end.join
    end

end
