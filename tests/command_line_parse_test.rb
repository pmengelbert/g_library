require 'test/unit'
require_relative '../modules/errors/'
require_relative '../modules/command_line_parse'

class CommandLineParseTest < Test::Unit::TestCase
  
  include Errors

  def setup
    ARGV.each_index do |i|
      ARGV.delete_at(i)
    end
    @options = {}
    
  end

    #_, _ = get_cli_options("/tmp/test.json", {})

  def test_command_line_parse_search_mode_no_flags
    ARGV << "harry" 
    ARGV << "potter"
    options = get_cli_options
    assert options.size > 0
  end

  def test_command_line_parse_search_mode_with_flags
    %w[-t potter -a rowling -p blablabla].each do |s|
      ARGV << s
    end
    options = get_cli_options
    assert options[:title] == "potter" &&
      options[:author] == "rowling" &&
      options[:publisher] == "blablabla"
  end

  def test_command_line_parse_search_mode_with_alternative_flags
    %w[--title potter --author rowling --publisher blablabla].each do |s|
      ARGV << s
    end
    options = get_cli_options
    assert options[:title] == "potter" &&
      options[:author] == "rowling" &&
      options[:publisher] == "blablabla"
  end

  def test_command_line_parse_library_mode
    %w[-t hello -l].each { |s| ARGV << s }
    ARGV << "-f"
    ARGV << File.join(File.expand_path("..", File.dirname(__FILE__)), "saved_libraries", "tmp.json")
    options = get_cli_options
    assert options.nil?
  end

end
