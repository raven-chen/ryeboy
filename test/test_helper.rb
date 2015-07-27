ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.default_driver = :selenium_chrome

ActionController::TestCase.send :include, Devise::TestHelpers
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  setup do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end

  def login user
    visit root_path

    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password

    click_button "登陆"

    assert_text "登陆成功"
  end
end
