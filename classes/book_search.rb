require 'json'
require_relative '../common/api_query'
require_relative '../common/google_api_url'
require_relative '../common/errors'

class BookSearch
  include ApiQuery
  include Enumerable

  attr_reader :selected_results, :full_results, :url

  def initialize(args)
    @args = args.dup

    num_results = @args.delete(:num) || 5

    raise ArgumentError unless searchable_arguments?

    @args = format_args
    @url = make_url

    raise NoInternetError unless connected_to_internet?

    response = get_response(@url)
    raise SearchError unless correct_response_code?(response.code)

    @full_results = JSON.parse(response.body)

    num = full_results['totalItems']
    raise NoResults unless num > 0

    @selected_results = full_results['items'].first(num_results)
    @selected_results.map! { |res| format_hash res }

  end

  #Only five results are iterated over; This behavior is easily changed by either
  #passing a :num value when initializing a BookSearch, or by using full_results
  #below, instead of selected_results
  def each
    return to_enum :each unless block_given?
    selected_results.each { |r| yield(r) }
  end

  #Likewise, only five results are accessible here; see the previous note.
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

    def format_args(args = @args)
      result = args.map { |k, v| [k,v].map(&:to_s) }.to_h
      result.reject { |k, v| v.empty? }
      return result.to_h
    end

    def searchable_arguments?(args = @args)
      args.keys.any? do |k| 
        %i[search title author publisher subject isbn lccn oclc].include?(k)
      end
    end


    #gets the 'volumeInfo' property from the results, and adds the 'id' property.
    def format_hash(hash)
      hash['volumeInfo'].merge( { 'id' => hash['id'] } )
    end

    #Add the base url and the formatted arg list together, and make sure
    #there are no spaces
    def make_url
      (BASE_API_URL + make_url_arg_list).gsub(/ /, "+")
    end

    #for testing purposes only
    def args
      @args
    end

end
