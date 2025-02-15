require 'test/unit'

require_relative '../exec_helpers/exec_helper.rb'
require_relative '../lib/book_search.rb'
require_relative '../lib/user_library.rb'

class UserLibraryTest < Test::Unit::TestCase
  
  

  SEARCH_RESULTS = BookSearch.new(search: "harry", title: "harry potter", author: "rowling")

  def setup
    s = SEARCH_RESULTS
    b = UserBook.new(s[0])
    @l = UserLibrary.new(nonpersistent: true)
    @l.add(b)
  end

  def test_add_method_non_book
    assert_raise( NotABook ) { @l.add({}) }
  end

  def test_add_method_duplicate_book
    assert_raise( BookDuplicateError ) { @l.add UserBook.new SEARCH_RESULTS[0] }
  end

  def test_add_method_correct_functioning
    old_size = @l.to_a.size
    @l.add UserBook.new SEARCH_RESULTS[1] 
    assert @l.to_a.size > old_size
  end

  def test_delete_method
    old_size = @l.to_a.size
    @l.delete(0)
    assert @l.to_a.size < old_size
  end

  def test_persistence_error
    assert_raise ( PersistenceError ) { @l.save }
  end

  def test_for_invalid_JSON_data
    file = File.join File.expand_path("..", File.dirname(__FILE__)), "saved_libraries", "tmp.json"
    filename = File.absolute_path(file)
    filename.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
    File.write(filename, "908ygu08ygyuiu-9u0hi////{}{}{}:")
    assert_raise(JSON::ParserError) do
      @l.send(:set_filename, filename) 
      @l.send(:get_raw_JSON_data)
    end
  end

  def test_for_invalid_books
    assert_raise(NotABook) { @l.add("string") }
  end

  def test_error_if_save_location_is_without_permission
    root = ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i } ? "C:\\" : "/"
    @l.send(:set_filename, "#{root}library.json")
    assert_raise(Errno::EACCES) { @l.save }
  end

  def test_for_successful_file_save
    file = File.join File.expand_path("..", File.dirname(__FILE__)), "saved_libraries", "tmp.json"
    file.gsub!(/\//, '\\') if ENV.values.any? { |v| v =~ /[A-Z]:\\Windows/i }
    @l.send(:set_filename, File.absolute_path(file))
    @l.save
    assert_nothing_raised(Exception) { File.open(@l.filename) }
  end

end
