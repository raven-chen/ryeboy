ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

ActionController::TestCase.send :include, Devise::TestHelpers
class ActiveSupport::TestCase
end
