source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)).chomp

gem 'rails', '~> 4.2.0'
gem 'pg'
gem 'unicorn'

# Asset Pipeline
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

gem 'spreadsheet'
gem 'kaminari'

group :development, :test do
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails'
  gem 'capybara'

  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'ruby_gntp'

  gem 'codeclimate-test-reporter', require: false
end
