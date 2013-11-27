# RailsAdmin config file. Generated on July 08, 2013 21:21
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|


  ################  Global configuration  ################
  RailsAdmin.config do |config|
    config.authorize_with :cancan
  end
  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Tao', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = ["UserTask", "Group", "UserActivity", "FundExchangeActivity", "Document"]

  # Include specific models (exclude the others):
  # config.included_models = []

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:

  config.model 'User' do
    hide_attributes = [:reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at,
                  :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :password,
                  :password_confirmation, :roles_mask, :user_activities, :fund_exchange_activities, :fines, :my_tasks, :tasks, :exercises]

    edit do
      hide_attributes.each do |attr|
        configure(attr) do
          hide
        end
      end
    end

    show do
      hide_attributes.each do |attr|
        configure(attr) do
          hide
        end
      end
    end
  end

  config.model 'Task' do
    list do
      field :name
      field :description
    end

    edit do
      field :name
      field :description
    end

    show do
      field :name
      field :description
    end
  end

  config.model "Fine" do
    list do
      field :user do
        searchable [{User => :name}]
        queryable true
      end

      field :amount do
        searchable false
      end
      field :date
      field :paid
      field :reason do
        searchable false
      end
      field :comment do
        searchable false
      end
    end
  end
end
