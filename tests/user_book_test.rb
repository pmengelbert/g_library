require 'test/unit'
require_relative '../modules/errors'
require_relative '../lib/user_book'

class UserBookTest < Test::Unit::TestCase
  include Errors

  SEARCH_RESULTS = BookSearch.new(search: "harry", title: "harry potter", author: "rowling")

  def setup
    s = SEARCH_RESULTS
    @b = UserBook.new(s[0])
  end

  def test_parameters_should_be_passed
    %i[title authors publisher].each do |sym|
      assert !@b.send(sym).empty?
    end
  end

  def test_authors_attr_should_be_string
    assert_instance_of String, @b.authors 
    assert_instance_of String, @b.author
  end

  def test_for_valid_arguments
    assert_raise(ArgumentError) { UserBook.new("string") }
  end

end
