Gem::Specification.new do |s|
  s.name        = 'glibrary'
  s.version     = '0.0.5'
  s.date        = '2019-10-26'
  s.summary     = "glibrary"
  s.description = "A simple command line program that queries the Google Books API Query and lets you save a list of books you plan to read."
  s.authors     = ["Peter Engelbert"]
  s.email       = 'pmengelbert@gmail.com'
  s.files       = [
        "modules/api_query.rb",
        "modules/command_line_parse.rb",
        "modules/errors.rb",
        "modules/exec_helper.rb",
        "modules/google_api_url.rb",
        "modules/user_prompt.rb",
        "lib/book_search.rb",
        "lib/user_book.rb",
        "lib/user_library.rb",
        "saved_libraries/.gitkeep"
  ]
  s.require_paths = ["modules", "saved_libraries", "lib"]
  s.homepage    =
    'https://github.com/pmengelbert/g_library'
  s.license       = 'MIT'
  s.executables << 'glibrary'
end
