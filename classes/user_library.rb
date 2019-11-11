require 'json'
require_relative '../common/errors'
require_relative 'user_book'

class UserLibrary
  include Enumerable

  attr_reader :books, :filename

  def initialize(args = {})

    @books = []

    @filename = nil

    load_saved_library!(args[:filename]) unless (@nonpersistent = args[:nonpersistent])

  end

  def add(book)
    (raise NotABook; return) unless valid?(book)
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
    puts pretty_export
  end

  def pretty_export
    a = [""]
    each_with_index do |b, i|
      j = i+1
      a << "%s%s%s" % ["#{j}.)--", b['id'], "-----"]
      a << b.pretty_export
      a << ""
    end
    a << ""
    a.join("\n")
  end

  private
    def valid?(b)
      b.respond_to?(:info)
    end

    def set_filename(name)
      @filename = name
    end

    def load_saved_library!(filename)
      f = filename || "saved_libraries/library.json"
      @filename = File.absolute_path(f)

      if File.exist?(filename)
        file = File.open(filename)
        book_array = JSON.parse(file.read)
        
        @books = book_array.map { |d| UserBook.new(d) }
        raise ArgumentError unless books.all? { |b| valid?(b) }
      end
    end


end

