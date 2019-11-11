Dir["#{__dir__}/*"].each do |fn|
  require_relative fn
end
