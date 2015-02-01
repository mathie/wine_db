source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)).chomp

gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'puma'

# Asset Pipeline
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'bower-rails'
gem 'angular-rails-templates'

gem 'spreadsheet'
gem 'kaminari'
gem 'jbuilder'

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails'
  gem 'capybara'

  gem 'guard-rspec', require: false
  gem 'guard-bundler', require: false
  gem 'guard-rubocop', require: false
  gem 'ruby_gntp'

  gem 'codeclimate-test-reporter', require: false

  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end
