lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "order_as_arbitrary/version"

Gem::Specification.new do |spec|
  spec.name          = "order_as_arbitrary"
  spec.version       = OrderAsArbitrary::VERSION
  spec.authors       = ["Vita"]
  spec.email         = ["qs2811531898@gmail.com"]
  spec.summary       = "Add arbitrary ordering to ActiveRecord queries."
  spec.description   = "Obtain ActiveRecord results with a custom ordering "

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 6.0.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "codecov"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"

end
