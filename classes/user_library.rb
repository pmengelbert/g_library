require 'json'
require_relative '../common/errors'

class UserLibrary
  include Enumerable

  attr_reader :books, :filename

  def initialize(sourcefile = nil)

    @books = []

    if sourcefile
      @filename = File.absolute_path(sourcefile, valid_class = UserBook)

      if File.exist?(filename)
        file = File.open(filename)
        book_array = JSON.parse(file.read)
        @books = book_array.map { |d| valid_class.new(d) }
      end
    else
      @filename = File.absolute_path("saved_libraries/library.json")
    end

    raise "Invalid Data" unless books.all? { |b| valid?(b) }
  end

  def add(book)
    (raise DataError "Invalid Data"; return) unless valid?(book)
    @books << book
  end

  def save
    File.write(filename, to_json)
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

  def pretty_print
    puts ""
    each do |b|
      puts "-"*5 + b['id'] + "-" * 5
      %w[title author publisher].each do |ind|
        puts "%s: %s" % [ind.capitalize, b[ind]]
        puts ""
      end
    puts ""
    puts ""
    end
    puts ""
  end

  private
    def valid?(b)
      b.respond_to?(:info)
    end

    def set_filename(name)
      @filename = name
    end

end

