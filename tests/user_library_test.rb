require 'test/unit'

require_relative '../classes/book_search.rb'
require_relative '../classes/user_library.rb'

class UserLibraryTest < Test::Unit::TestCase

  def setup
    s = BookSearch.new(search: "harry", title: "harry potter", author: "rowling")
    b = UserBook.new(s[0])
    @l = UserLibrary.new(filename: "/tmp/library.json")
    @l.add(b)
  end

  def test_delete_method
    ul = UserLibrary.new(nonpersistent: true)
    ul.add({})
    assert ul.to_a.size == 1
    ul.delete(0)
    assert ul.to_a.size == 0
  end

  def test_for_invalid_JSON_data
    File.write("/tmp/test.json", "908ygu08ygyuiu-9u0hi////{}{}{}:")
    assert_raise(JSON::ParserError) { UserLibrary.new(filename: "/tmp/test.json") }
  end

  def test_for_invalid_books
    assert_raise("Invalid Data") { @l.add("string") }
  end

  def test_error_if_save_location_is_without_permission
    @l.send(:set_filename, "/library.json")
    assert_raise(Errno::EACCES) { @l.save }
  end

  def test_for_successful_file_save
    @l.save
    assert_nothing_raised(Exception) { File.open(@l.filename) }
  end

  Test::Unit.at_exit do
    filename = "/tmp/library.json"
    system("rm #{filename}") if File.exist?(filename)
  end

end
