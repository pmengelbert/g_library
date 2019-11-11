require 'json'
require_relative '../modules/errors'
require_relative '../modules/exec_helper'
require_relative 'user_book'


class UserLibrary
  include Enumerable
  include ExecHelper
  include Errors

  attr_reader :books, :filename

  def initialize(args = {})

    @books = []
    @nonpersistent = args[:nonpersistent]

    unless nonpersistent?
      @filename = args[:filename] || 
        File.join(File.dirname(__FILE__), "../saved_libraries/library.json")

      determine_filename!
      load_saved_library!
    end

  end

  def add(book)
    raise NotABook unless valid?(book)
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
      @nonpersistent = false
      @filename = name
      prepare_filename_for_os!(@filename)
    end

    def determine_filename!
      @filename = File.absolute_path(@filename)
      prepare_filename_for_os!
    end

    def get_raw_JSON_data
      file = File.open(@filename)
      JSON.parse(file.read)
    end

    def load_saved_library!
      if File.exist?(@filename)
        book_data_set = get_raw_JSON_data
        book_data_set.each { |info| add(UserBook.new(info)) }
        raise ArgumentError unless books.all? { |b| valid?(b) }
      end
    end


end

