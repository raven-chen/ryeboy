source 'https://rubygems.org'
ruby '2.0.0', :patchlevel => '594'

gem 'rails', '3.2.21'

gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'uglifier', '>= 1.0.3'
end

gem "twitter-bootstrap-rails", :branch => "bootstrap3"
gem 'unicorn'

gem 'rails_12factor'

group :development do
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails'
  gem "capistrano-rvm"
end

group :development, :test do
  gem "pry"
end

gem 'jquery-rails', '~> 2.0.0'
gem 'jquery-ui-rails'

gem 'rails_admin'
gem "rich"
gem "cancan"
gem "kaminari"
gem 'acts-as-taggable-on', '~> 3.4'
gem "paperclip", "~> 4.3"


group :test do
  gem 'factory_girl'
  gem "factory_girl_rails"
  gem "shoulda-context"
  gem "shoulda-matchers"
  gem "capybara"
  gem "database_cleaner"
  gem 'selenium-webdriver'
end

gem "devise"
gem "soft_deletion"
