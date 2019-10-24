require 'json'
require_relative 'common/api_query'
require_relative 'common/google_api_key'
require_relative 'classes/user_book'
require_relative 'classes/book_search'

class UserLibrary
  include Enumerable

  attr_accessor :books, :filename

  def initialize(sourcefile = nil)
    if sourcefile
      @filename = File.absolute_path(sourcefile)
      @books = JSON.parse(@filename)
    else
      @filename = File.absolute_path("library.json")
      @books = []
    end
  end

  def add(book)
    @books << book
  end

  def save
    File.write(@filename, to_json)
  end

  def each
    @books.each { |b| yield(b) }
  end

  def to_json
    a = []
    @books.each_with_index { |b, i| a << b.info }
    "{\n" + JSON.pretty_generate(a) + "\n}"
  end

end

