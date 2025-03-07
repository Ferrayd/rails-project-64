# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.5'
gem 'ancestry', '~> 4.3'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'devise'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'slim'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'faker'
  gem 'minitest-power_assert'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'slim_lint'
  gem 'sqlite3'
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'pg'
end
