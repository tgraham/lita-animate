Gem::Specification.new do |spec|
  spec.name          = "lita-animate"
  spec.version       = "2.0.0"
  spec.authors       = ["Igor Adrov"]
  spec.email         = ["nucleartux@gmail.com"]
  spec.description   = %q{A Lita handler for fetching gifs from Google.}
  spec.summary       = %q{A Lita handler for fetching gifs from Google.}
  spec.homepage      = "https://github.com/nucleartux/lita-animate"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 2.0"

  spec.add_development_dependency "bundler", ">= 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end