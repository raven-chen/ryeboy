if ENV['CI']
  source 'https://rubygems.org'
else
  source 'https://ruby.taobao.org'
end

ruby '2.2.3'

gem 'rails', "~>4.2.2"

gem 'mysql2', '~> 0.3.18'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails", '~> 5.0.3'

  gem 'uglifier', '>= 1.0.3'
end

gem "twitter-bootstrap-rails"
gem 'unicorn'

group :development do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails'
end

group :development, :test do
  gem "pry"
end

gem "airbrake", '4.3.0'
gem 'jquery-rails', '~> 2.0.0'
gem 'jquery-ui-rails'

gem "cancancan"
gem "kaminari"
gem 'acts-as-taggable-on', '~> 3.4'
gem "paperclip", "~> 4.3"
gem "protected_attributes"

group :test do
  gem 'factory_girl'
  gem "factory_girl_rails"
  gem "shoulda-context"
  gem "shoulda-matchers"
  gem "capybara"
  gem "database_cleaner"
  gem 'selenium-webdriver'
end

gem 'devise', :git => 'https://github.com/plataformatec/devise.git'
gem "soft_deletion"
gem 'rack', '~> 1.6.4'
