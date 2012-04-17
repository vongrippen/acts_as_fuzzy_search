# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_fuzzy_search/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jordan Babe"]
  gem.email         = ["jorbabe@gmail.com"]
  gem.description   = %q{ Return Activerecord records that match a search query. Ideally used for small sets of data and simple search terms.}
  gem.summary       = %q{ AR find based on word matching }
  gem.homepage      = "http://github.com/jbabe/acts_as_fuzzy_search"
  
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_fuzzy_search"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsFuzzySearch::VERSION
  
  gem.add_dependency "text", "~> 1.0.0"
  gem.add_dependency "nokogiri"
  
  # gem.add_dependency "fuzzy-string-match", "~> 0.9.0" Drop this until we 

  gem.add_development_dependency "minitest"
end
