source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta2', '< 5.1'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.3.18', '< 0.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Figaro for setting environment variables for secrets that aren't included with the source code
gem 'figaro', '~> 1.1.1'
# Helps to make http call to third party API and service
gem 'httparty', '~> 0.13.7'
# Validation of dates, times and datetimes
gem 'validates_timeliness', '~> 4.0.2'
# Library with a simple, robust and scaleable authorization system
gem 'pundit'

group :development, :test do
  # Call 'binding.pry' anywhere in the code to stop execution and get a debugger console
  gem 'pry-rails', '~> 0.3.4'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # For deployment
  gem 'capistrano-rails', '~> 1.1.3'
  gem 'capistrano-rvm', '~> 0.1.2'
  gem 'capistrano-bundler', '~> 1.1.4'
end

group :development, :test do
  # Generate fake data for factories.
  gem 'faker', '~> 1.5.0'
  # For Test Driven Development
  gem 'rspec-rails', '~> 3.1.0'
  # Feeding test data to the test suite.
  gem 'factory_girl_rails', '~> 4.5.0'
end

group :test do
  # Database_cleaner for cleaning test database.
  gem 'database_cleaner', '~> 1.5.1'
  # Simplecove for generating the code coverage report
  gem 'simplecov', require: false
  # Codeclimate-test-reporter for sending the coverage report to code climate
  gem 'codeclimate-test-reporter', '~> 0.4.8'
  # Provides Test::Unit and RSpec-compatible one-liners that test common Rails functinality.
  gem 'shoulda-matchers', '~> 3.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
