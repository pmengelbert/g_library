require 'json'

class Hash
  def info
    self
  end
end

class UserBook

  attr_accessor :title, :publisher, :info, :id

  def initialize(book_data = {})
    raise ArgumentError unless book_data.is_a?(Hash)

    #The main attributes of the book:
    @info = book_data

    #The most commonly attributes, for ease of use
    @id = info['id'] || ""
    @title = info['title'] || ""
    @authors = info['authors'] || "" 
    @publisher = info['publisher'] || ""
  end

  #get any attribute, like with a hash
  #ex self['title']
  def [](key)
    return authors if key =~ /authors?/i
    info[key]
  end

  def authors
    @authors.join(', ')
  end

  #Be a little bit forgiving if the user types "authors"
  def author
    authors
  end

end
