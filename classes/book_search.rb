require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_key'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results

  def initialize(args)
    num_results = args.delete(:num) || 5
    @q = args.delete(:search) || ""

    @raw_args = args.reject { |k, v| k == :num || k == :search }
      .map { |k, v| [k.to_s, v] }

    url_arg_list = make_url_arg_list

    @full_results = get_response_hash(make_url)
    @selected_results = @full_results['items'].first(num_results)
  end

  def each
    return to_enum :each unless block_given?
    @selected_results.each { |r| yield(r) }
  end

  def [](index)
    get_volume_info @selected_results[index]
  end

  def to_json
    h = map { |r| { r['id'] => r['volumeInfo'] } }
    JSON.pretty_generate(h)
  end

  private 
    def make_url_arg_list
      "&q=" + @q + @raw_args.map do |k, v|
        k = ("in" + k) if %w[title author publisher].include?(k)
        "+%s:%s" % [k, v]
      end.join
    end

    def get_volume_info(item)
      item['volumeInfo']
    end

    def make_url
      BASE_API_URL + make_url_arg_list
    end

end
