require 'test/unit'
require_relative 'g_search.rb'

class TestBookSearch < Test::Unit::TestCase

  def setup
    @s = Search.new(search: "harry", title: "harry potter", author: "rowling")
  end

  def test_url_making_function_with_proper_input
    assert_equal @s.send(:make_url_arg_list), "&q=harry+intitle:harry potter+inauthor:rowling"
  end

end
