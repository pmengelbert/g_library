require 'json'

class UserLibrary
  include Enumerable

  attr_reader :books, :filename

  def initialize(sourcefile = nil)

    @books = []

    if sourcefile
      @filename = File.absolute_path(sourcefile)

      if File.exist?(filename)
        file = File.open(filename)
        @books = JSON.parse(file.read).map { |d| UserBook.new(d) }
      end
    else
      @filename = File.absolute_path("saved_libraries/library.json")
    end

    raise "Invalid Data" unless books.all? { |b| valid?(b) }
  end

  def add(book)
    unless valid?(book)
      raise "Invalid Data" 
      return
    end
    @books << book
  end

  def books=(book)
    add(book)
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

  private
    def valid?(b)
      b.is_a?(UserBook) && b.respond_to?(:info)
    end

    def set_filename(name)
      @filename = name
    end

end

