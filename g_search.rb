require_relative 'common/api_query'
require_relative 'common/google_api_key'

class Search
  include ApiQuery

  attr_reader :hash

  def initialize(args = {})
    @raw_args = args.map { |k, v| [k.to_s, v] }
    url_arg_list = make_url_arg_list

    @hash = get_response_hash(BASE_API_URL + url_arg_list)
  end

#  private 
    def make_url_arg_list
      @raw_args.map do |k, v|
        k = ("in" + k) if %w[title author publisher].include?(k)
        "&%s=%s" % [k, v]
      end.join
    end

end
