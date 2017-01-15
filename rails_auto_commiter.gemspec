# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_auto_commiter/version'

Gem::Specification.new do |spec|
  spec.platform      = Gem::Platform::RUBY
  spec.name          = "rails_auto_commiter"
  spec.version       = RailsAutoCommiter::VERSION
  spec.authors       = ["Hiroki Shirai"]
  spec.email         = ["shiraihiroki.jp@gmail.com"]

  spec.summary       = %q{Auto git commiter for Ruby on Rails.}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/hirokishirai/rails_auto_commiter'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
