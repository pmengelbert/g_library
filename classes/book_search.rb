require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_url'
require_relative '../common/errors'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results

  def initialize(args)
    @args = args.dup
    num_results = @args.delete(:num) || 5

    raise ArgumentError unless args.keys.any? do |k| 
      %i[title author publisher subject isbn lccn oclc].include?(k)
    end

    @args = args.reject { |k, v| v.nil? || v.empty? }.to_h
    @args = @args.map { |k, v| [k,v].map(&:to_s) }.to_h

    url = make_url
    pp url

    response = get_response(url)
    raise SearchError unless response.code == "200"

    @full_results = JSON.parse(response.body)

    num = full_results['totalItems']
    raise NoResults unless num > 0

    @selected_results = full_results['items'].first(num_results).map { |res| format_hash res }

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
      url = ["?q="]

      q = @args.delete('search')
      url << q.to_s

      url << @args.map do |k,v|
        k = ("in" + k) if %w[title author publisher].include?(k)
        "%s:%s" % [k, v] 
      end

      url.reject!(&:empty?)

      url[0] + url[1, url.length-1].join("+")

    end

    def format_hash(hash)
      hash['volumeInfo'].merge( { 'id' => hash['id'] } )
    end

    def make_url
      (BASE_API_URL + make_url_arg_list).gsub(/ /, "+")
    end

    def args
      @args
    end

end
