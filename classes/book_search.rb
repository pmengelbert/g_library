require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_key'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results

  def initialize(args)
    raise ArgumentError unless (args.keys - [:num]).any? { |k| %i[title author publisher subject isbn lccn oclc].include?(k) }
    num_results = args.delete(:num) || 5
    @q = args.delete(:search) || ""

    @raw_args = args.map { |k, v| [k.to_s, v.to_s] }.to_h

    url_arg_list = make_url_arg_list

    @full_results = get_response_hash(make_url)
    @selected_results = @full_results['items'].first(num_results)
  end

  def each
    return to_enum :each unless block_given?
    @selected_results.each { |r| yield(r) }
  end

  def [](index)
    add_id_to @selected_results[index]
  end

  def to_json
    JSON.pretty_generate(@selected_results)
  end

  private 
    def make_url_arg_list
      "&q=" + @q + @raw_args.map do |k, v|
        k = ("in" + k) if %w[title author publisher].include?(k)
        "+%s:%s" % [k, v]
      end.join
    end

    def add_id_to(hash)
      hash['volumeInfo'].merge( { 'id' => hash['id'] } )
    end

    def make_url
      BASE_API_URL + make_url_arg_list
    end

    def raw_args
      @raw_args
    end

end
