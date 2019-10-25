require 'json'

class UserBook

  attr_reader :authors
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
    info[key]
  end

  def[]=(key, value)
    @info[key] = value
  end

  def author
    @authors
  end

  def author=(str)
    @authors << str
  end

end
