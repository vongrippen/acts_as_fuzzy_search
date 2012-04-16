# ActsAsFuzzySearch

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_fuzzy_search'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_fuzzy_search

## Usage

		# app/models/foobar.rb
		class Foobar < ActiveRecord::Base
			acts_as_fuzzy_search
			
			# Or pass it some options:
			# acts_as_fuzzy_search(:scope => :your_scope_name, :search_algorithm => :white_similarity)
		end
		
		# Elsewhere in your code
		Foobar.find_by_fuzzy_search 'smthing'
		
		# Or pass it some options
		Foobar.find_by_fuzzy_search 'smthing', {:date_format => "%B %d %Y", :search_algorithm => :levenshtein_distance})
		
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
