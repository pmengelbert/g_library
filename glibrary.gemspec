Gem::Specification.new do |s|
  s.name        = 'glibrary'
  s.version     = '0.0.1'
  s.date        = '2019-10-26'
  s.summary     = "Glibrary"
  s.description = "A simple Google Books API Query program"
  s.authors     = ["Peter Engelbert"]
  s.email       = 'pmengelbert@gmail.com'
  s.files       = [
    "common/google_api_url.rb",
    "common/search_error.rb",
    "common/api_query.rb",
    "common/errors.rb",
    "classes/book_search.rb",
    "classes/user_book.rb",
    "saved_libraries/.gitkeep",
    "classes/user_library.rb"
  ]
  s.require_paths = ["common", "saved_libraries", "classes"]
  s.homepage    =
    'https://github.com/pmengelbert/g_library'
  s.license       = 'MIT'
  s.executables << 'glibrary'
end
