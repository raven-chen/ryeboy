if Rails.env == "production"
  Bugsnag.configure do |config|
    config.api_key = "188ba657ab8a98f2391f09d5ef66c29f"
  end
end
