require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_key'
require_relative '../common/search_error'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results

  def initialize(args)
    raise ArgumentError unless (args.keys - [:num]).any? { |k| %i[title author publisher subject isbn lccn oclc].include?(k) }
    num_results = args.delete(:num) || 5
    @q = args.delete(:search) || ""
    args.keys.each do |k|
      args.delete(k) if args[k] == nil || args[k].empty?
    end

    @raw_args = args.map { |k, v| [k.to_s, v.to_s] }.to_h

    url = make_url

    @full_results = get_response_hash(url)
    if (num = @full_results['totalItems']) && num > 0 && get_response_code(url) == "200"
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
      "&q=" + @q + @raw_args.map.with_index do |pair, i|
        pair[0] = ("in" + pair[0]) if %w[title author publisher].include?(pair[0])
        (i == 0 ? "%s:%s" : "+%s:%s")  % [pair[0], pair[1]]
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
