require 'test/unit'
require_relative '../classes/book_search.rb'

class TestBookSearch < Test::Unit::TestCase

  def setup
    @s = BookSearch.new(search: "harry", title: "harry potter", author: "rowling")
  end

  def test_searchable_arguments_function
    assert !@s.send(:searchable_arguments?, 
                    { titel: "The Classical Style", auhtor: "Rosen" })
  end

  def test_url_making_function_with_proper_input
    assert_equal @s.url,
      "https://www.googleapis.com/books/v1/volumes?q=harry+intitle:harry+potter+inauthor:rowling"
  end

  def test_correct_search_should_get_code_200
    assert_equal @s.send(:get_response_code, @s.send(:make_url)), "200"
  end
  
  def test_incorrect_search_should_not_get_code_200
    url = "https://www.googleapis.com/books/v1/volumes?q=&intitle=harry"
    assert_not_equal @s.send(:get_response_code, url), "200"
  end

  def test_no_parameters_should_result_in_error
    assert_raise( ArgumentError ) { b = BookSearch.new }
  end

  def test_error_unless_at_least_one_correct_parameter_except_num
    assert_raise( ArgumentError) { b = BookSearch.new(asdf: "hello", qwer: "goodbye") }
    assert_raise( ArgumentError) { b = BookSearch.new(asdf: "hello", num: 4) }
  end

  def test_arguments_should_automatically_be_recast_as_strings
    x = BookSearch.new(title: 1984)
    y = BookSearch.new(title: "1984")
    assert_equal x.send(:args)['title'], y.send(:args)['title']
  end

  def test_url_generation
    x = BookSearch.new(search: "michelle", author: "obama", title: "becoming")
    y = BookSearch.new(author: "obama", title: "becoming")
    assert_equal x.url, "https://www.googleapis.com/books/v1/volumes?q=michelle+inauthor:obama+intitle:becoming"
    assert_equal y.url, "https://www.googleapis.com/books/v1/volumes?q=inauthor:obama+intitle:becoming"
  end

end
