require 'json'
require_relative '../common/errors'
require_relative 'user_book'

class UserLibrary
  include Enumerable

  attr_reader :books, :filename

  def initialize(args = {})

    @books = []

    load_saved_library(args[:filename]) unless (@nonpersistent = args[:nonpersistent])

  end

  def add(book)
    (raise DataError; return) unless valid?(book)
    raise BookDuplicateError if any? { |b| b['id'] == book['id'] }
    @books << book
  end

  def delete(index)
    @books.delete_at(index)
  end

  def nonpersistent?
    @nonpersistent
  end

  def <<(book)
    add(book)
  end

  def save
    raise PersistenceError if nonpersistent?
    File.write(@filename, to_json)
  end

  def size
    @books.size
  end

  def length
    size
  end

  def each
    return to_enum :each unless block_given?
    @books.each { |b| yield(b) }
  end

  def [](index)
    @books[index]
  end

  def to_json
    a = @books.map do |b| 
      b.info 
    end
    JSON.pretty_generate(a)
  end

  def pretty_print
    puts ""
    each_with_index do |b, i|
      j = i+1
      puts "%s%s%s" % ["#{j}.)--", b['id'], "-----"]
      puts b.pretty_export
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

    def load_saved_library(filename)
      @filename = File.absolute_path(filename || "saved_libraries/library.json")

      if File.exist?(filename)
        file = File.open(filename)
        book_array = JSON.parse(file.read)
        
        @books = book_array.map { |d| UserBook.new(d) }
        raise ArgumentError unless books.all? { |b| valid?(b) }
      end
    end


end

