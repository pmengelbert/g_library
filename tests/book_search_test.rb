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

  def test_format_args
    result = @s.send(:format_args,
              { title: "The Classical Style", author: "Rosen" } )
    assert result.all? { |k, v| k.is_a?(String) && v.is_a?(String) }
  end

  def test_connected_to_internet?
    assert !@s.send(:connected_to_internet?, "jidooifj.iuhewi")
    #assumes we are connected to the internet
    assert @s.send(:connected_to_internet?)
  end

  def test_correct_response_code?
    url1 = "https://www.googleapis.com/books/v1/volumes?q=&intitle=harry"
    url2 = @s.url
    r1 = Net::HTTP.get_response(URI.parse(url1)).code
    r2 = Net::HTTP.get_response(URI.parse(url2)).code
    assert !@s.send(:correct_response_code?, r1)
    assert @s.send(:correct_response_code?, r2)
  end

  def test_url_making_function_with_proper_input
    assert_equal @s.url,
      "https://www.googleapis.com/books/v1/volumes?q=harry+intitle:harry+potter+inauthor:rowling"
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
