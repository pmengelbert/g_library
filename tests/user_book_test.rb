require 'test/unit'
require_relative '../g_library.rb'

class UserBookTest < Test::Unit::TestCase

  def setup
    s = BookSearch.new(name: "harry", title: "harry potter", author: "rowlilng")
    @b = UserBook.new(s[0]['volumeInfo'])
  end

end
