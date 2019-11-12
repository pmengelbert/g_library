require 'json'
require_relative '../modules/errors'

class UserBook
  

  attr_accessor :title, :publisher, :info, :id

  def initialize(book_data = {})
    raise ArgumentError unless book_data.is_a?(Hash)

    @info = book_data

    @id = info['id'] || ""
    @title = info['title'] || ""
    @authors = info['authors'] || [] 
    @publisher = info['publisher'] || ""
  end

  def pretty_export
    str = []
    %w[title author publisher].each do |ind|
      str << "%s: %s" % [ind.capitalize, self[ind]]
    end
    return str.join("\n")
  end

  def [](key)
    return authors if key =~ /authors?/i
    info[key]
  end

  def authors
    @authors.join(', ')
  end

  def author
    authors
  end

end
