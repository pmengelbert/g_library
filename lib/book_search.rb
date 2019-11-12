require 'json'
require_relative '../modules/api_query'
require_relative '../modules/google_api_url'
require_relative '../modules/errors'

class BookSearch
  include ApiQuery
  include Enumerable
  include Errors

  attr_reader :selected_results, :full_results, :url

  def initialize(args)
    @args = args.dup

    num_results = @args.delete(:num) || 5

    raise ArgumentError unless self.class.searchable_arguments?(@args)

    @args = self.class.format_args(@args)
    @url = self.class.make_url(@args)

    raise NoInternetError unless connected_to_internet?

    response = get_response(@url)
    raise SearchError unless correct_response_code?(response.code)

    @full_results = JSON.parse(response.body)

    num = full_results['totalItems']
    raise NoResults unless num > 0

    @selected_results = full_results['items'].first(num_results)
    @selected_results.map! { |res| self.class.format_hash res }

  end

  def each
    return to_enum :each unless block_given?
    selected_results.each { |r| yield(r) }
  end

  def [](index)
    selected_results[index]
  end

  private 
    class << self
      def make_url_arg_list(args)
        url = ["?q="]

        q = args.delete('search')
        url << q.to_s

        url << args.map do |k,v|
          k = ("in" + k) if %w[title author publisher].include?(k)
          "%s:%s" % [k, v] 
        end

        url.reject!(&:empty?)
        url[0] + url[1, url.length-1].join("+")
      end

      def format_args(args)
        result = args.map { |k, v| [k,v].map(&:to_s) }.to_h
        result.reject! { |k, v| v.empty? }
        return result.to_h
      end

      def searchable_arguments?(args)
        args.keys.any? do |k| 
          %i[search title author publisher subject isbn lccn oclc].include?(k)
        end
      end


      def format_hash(hash)
        hash['volumeInfo'].merge( { 'id' => hash['id'] } )
      end

      def make_url(args)
        (BASE_API_URL + make_url_arg_list(args)).gsub(/ /, "+")
      end

      def args
        @args
      end
  end

end
