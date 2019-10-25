require 'json'

class UserBook

  attr_accessor :title, :publisher, :info, :id

  def initialize(args = {})
    raise ArgumentError unless args.is_a?(Hash)
    @info = args
    @id = info['id']
    @title = info['title'] || ""
    @authors = info['authors'] || []
    @publisher = info['publisher'] || ""
  end

  def to_json
    JSON.pretty_generate(info)
  end

  def [](key)
    return authors if key =~ /authors?/i
    info[key]
  end

  def[]=(key, value)
    @info[key] = value
  end

  def authors
    @authors.join(', ')
  end

  def author
    authors
  end

  def author=(str)
    @authors << str
  end

end
