# A sample Gemfile
source "https://rubygems.org"

group :lint do
  gem 'foodcritic-rackspace-rules'
  gem 'foodcritic'
  gem 'rubocop'
end

group :unit do
  gem 'berkshelf', '>= 3.0'
  gem 'chefspec'
  gem 'chef-sugar'
  # hardcode the version for now until 404s are resolved:
  # https://github.com/sethvargo/chefspec/issues/472
  gem 'chef-zero', '= 2.0.2'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end

group :development do
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rubocop'
  gem 'guard-rspec'
  gem 'fauxhai'
  gem 'pry-nav'
end
