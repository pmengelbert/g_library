Gem::Specification.new do |s|
  s.name        = 'glibrary'
  s.version     = '0.0.4'
  s.date        = '2019-10-26'
  s.summary     = "glibrary"
  s.description = "A simple command line program that queries the Google Books API Query and lets you save a list of books you plan to read."
  s.authors     = ["Peter Engelbert"]
  s.email       = 'pmengelbert@gmail.com'
  s.files       = [
        "common/google_api_url.rb",
        "common/exec_helper.rb",
        "common/api_query.rb",
        "common/user_prompt.rb",
        "common/errors.rb",
        "common/command_line_parse.rb",
        "classes/book_search.rb",
        "classes/user_book.rb",
        "classes/user_library.rb"
  ]
  s.require_paths = ["common", "saved_libraries", "classes"]
  s.homepage    =
    'https://github.com/pmengelbert/g_library'
  s.license       = 'MIT'
  s.executables << 'glibrary'
end
