require 'test/unit'
require_relative '../g_library.rb'

class TestBookSearch < Test::Unit::TestCase

  def setup
    @s = BookSearch.new(search: "harry", title: "harry potter", author: "rowling")
  end

  def test_url_making_function_with_proper_input
    assert_equal @s.send(:make_url_arg_list), "&q=harry+intitle:harry potter+inauthor:rowling"
  end

  def test_correct_search_should_get_code_200
    assert_equal @s.send(:get_response_code, @s.send(:make_url)), "200"
  end
  
  def test_correct_search_should_not_get_code_200
    url = "https://www.googleapis.com/books/v1/volumes?q=&intitle=harry"
    assert_not_equal @s.send(:get_response_code, url), "200"
  end

  def test_no_parameters_should_result_in_error
    assert_raise( ArgumentError ) { b = BookSearch.new }
  end

  def test_wrong_parameters_should_result_in_error
    assert_raise( ArgumentError) { b = BookSearch.new(asdf: "hello", qwer: "goodbye") }
  end

end
