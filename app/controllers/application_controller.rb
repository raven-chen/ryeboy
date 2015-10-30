class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  def process_query_params parameters, &block
    options = {}
    options = parameters.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    options
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:email, :name, :password, :password_confirmation]
  end
end
