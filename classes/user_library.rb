require 'json'

class UserLibrary
  include Enumerable

  attr_accessor :books, :filename

  def initialize(sourcefile = nil)
    if sourcefile
      @filename = File.absolute_path(sourcefile)
      file = File.open(@filename)
      @books = JSON.parse(file.read)
    else
      @filename = File.absolute_path("saved_libraries/library.json")
      @books = []
    end
    raise "Invalid Data" unless books.all { |b| valid?(b) }
  end

  def add(book)
    @books << book
  end

  def books=(book)
    add(book)
  end

  def save
    File.write(@filename, to_json)
  end

  def each
    return to_enum :each unless block_given?
    @books.each { |b| yield(b) }
  end

  def to_json
    a = @books.map do |b| 
      b.info 
    end
    JSON.pretty_generate(a)
  end

  private
    def valid?(b)
      b.respond_to?(:info)
    end

end

