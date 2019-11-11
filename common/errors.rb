module Errors
  class SearchError < StandardError
  end

  class BookDuplicateError < StandardError
  end

  class NoInternetError < StandardError
  end

  class NoResults < StandardError
  end

  class SelectionError < StandardError
  end

  class NotABook < StandardError
  end

  class UserQuits < StandardError
  end

  class PersistenceError < StandardError
  end
end
