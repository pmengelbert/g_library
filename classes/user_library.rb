require 'json'
require_relative '../common/errors'
require_relative 'user_book'

class UserLibrary
  include Enumerable

  attr_reader :books, :filename

  def initialize(sourcefile = nil, args = {})

    @books = []

    unless (@nonpersistent = args[:nonpersistent])
      if sourcefile
        @filename = File.absolute_path(sourcefile)

        if File.exist?(filename)
          file = File.open(filename)
          book_array = JSON.parse(file.read)
          
          @books = book_array.map { |d| UserBook.new(d) }
        end

      else
        #the default filename
        @filename = File.absolute_path("saved_libraries/library.json")
      end
    end

    #If the wrong type of data is provided
    raise ArgumentError unless books.all? { |b| valid?(b) }
  end

  def add(book)
    (raise DataError; return) unless valid?(book)
    @books << book
  end

  def delete(index)
    @books.delete_at(index)
  end

  def <<(book)
    add(book)
  end

  def save
    raise PersistenceError if @nonpersistent
    File.write(filename, to_json)
  end

  def size
    @books.size
  end

  def length
    size
  end

  #Iterates over ALL books
  def each
    return to_enum :each unless block_given?
    @books.each { |b| yield(b) }
  end

  def [](index)
    @books[index]
  end

  #For saving to files
  def to_json
    a = @books.map do |b| 
      b.info 
    end
    JSON.pretty_generate(a)
  end

  #For printing to the console
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
    #make sure whatever gets passed in responds to the ':info' message
    def valid?(b)
      b.respond_to?(:info)
    end

    #for testing purposes
    def set_filename(name)
      @filename = name
    end

end

