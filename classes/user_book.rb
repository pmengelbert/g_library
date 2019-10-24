require 'json'

class UserBook

  attr_accessor :title, :author, :publisher, :info

  def initialize(args = {})
    @info = args
    @title = args[:title]
    @author = args[:author]
    @publisher = args[:publisher]
  end

  def to_json
    JSON.pretty_generate(@info)
  end

end
