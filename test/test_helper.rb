require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end

# here we require all files, and then just reqire test_helper.rb when testing.
