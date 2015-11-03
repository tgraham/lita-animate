require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end

require "lita"
require "lita-animate"
require "lita/rspec"
Lita.version_3_compatibility_mode = false