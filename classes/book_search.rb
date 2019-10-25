require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_url'
require_relative '../common/search_error'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results

  def initialize(args)
    num_results = args.delete(:num) || 5

    raise ArgumentError unless args.keys.any? do |k| 
      %i[title author publisher subject isbn lccn oclc].include?(k)
    end

    @q = args.delete(:search)
    args.keys.each do |k|
      args.delete(k) if args[k].nil? || args[k].empty?
    end

    @raw_args = args.map { |k, v| [k.to_s, v.to_s] }.to_h

    url = make_url

    response = get_response(url)
    @full_results = JSON.parse(response.body)

    num = full_results['totalItems']

    if num && num > 0 && response.code == "200"
      @selected_results = full_results['items'].first(num_results).map { |res| format_hash res }
    else

      raise SearchError, "No results"
    end
  end

  def each
    return to_enum :each unless block_given?
    selected_results.each { |r| yield(r) }
  end

  def [](index)
    selected_results[index]
  end

  def to_json
    JSON.pretty_generate(selected_results)
  end

  private 
    def make_url_arg_list
      q = @q.to_s
      url = "?q="
      url += @raw_args.map.with_index do |(k,v), i|

        k = ("in" + k) if %w[title author publisher].include?(k)

        "%s%s:%s" % [i == 0 ? q : "+", k, v] 
      end.join
    end

    def format_hash(hash)
      hash['volumeInfo'].merge( { 'id' => hash['id'] } )
    end

    def make_url
      (BASE_API_URL + make_url_arg_list).gsub(/ /, "+")
    end

    def raw_args
      @raw_args
    end

end
