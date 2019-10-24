require_relative 'common/api_query'
require_relative 'common/google_api_key'

class Search
  include ApiQuery
  include Enumerable

  attr_reader :hash

  def initialize(args = {})
    num_results = args.delete(:num) || 5
    @q = args.delete(:search) || ""
    @raw_args = args.map { |k, v| [k.to_s, v] }
    url_arg_list = make_url_arg_list

    @hash = get_response_hash(BASE_API_URL + url_arg_list)
    @results = @hash['items'].first(num_results).map { |item| get_volume_info(item) }
  end

  def each
    @results.each { |r| yield(r) }
  end

  def [](index)
    @results[index]
  end

#  private 
    def make_url_arg_list
      "&q=" + @q + @raw_args.map do |k, v|
        k = ("in" + k) if %w[title author publisher].include?(k)
        "+%s:%s" % [k, v]
      end.join
    end

    def get_volume_info(item)
      item['volumeInfo']
    end

end
