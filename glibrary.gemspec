Gem::Specification.new do |s|
  s.name        = 'glibrary'
  s.version     = '1.1.0'
  s.date        = '2019-10-26'
  s.summary     = "glibrary"
  s.description = "A simple command line program that queries the Google Books API Query and lets you save a list of books you plan to read."
  s.authors     = ["Peter Engelbert"]
  s.email       = 'pmengelbert@gmail.com'
  s.files       = [
        "modules/api_query.rb",
        "exec_helpers/command_line_parse.rb",
        "globals/errors.rb",
        "exec_helpers/error_handler.rb",
        "exec_helpers/exec_helper.rb",
        "globals/google_api_url.rb",
        "exec_helpers/user_prompt.rb",
        "lib/book_search.rb",
        "lib/user_book.rb",
        "lib/user_library.rb",
        "saved_libraries/.gitkeep"
  ]
  s.require_paths = ["modules", "exec_helpers", "globals", "saved_libraries", "lib"]
  s.homepage    =
    'https://github.com/pmengelbert/g_library'
  s.license       = 'MIT'
  s.executables << 'glibrary'
end
