require 'json'

class Hash
  def info
    self
  end
end

class UserBook < Hash

  attr_accessor :title, :publisher, :info, :id

  def initialize(args = {})
    raise ArgumentError unless args.is_a?(Hash)
    @info = args
    @id = info['id']
    @title = info['title'] || ""
    @authors = info['authors'] || []
    @publisher = info['publisher'] || ""
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
