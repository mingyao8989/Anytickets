# RailsAdmin config file. Generated on August 20, 2012 11:39
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|

  config.authorize_with do
    authenticate_user!
    redirect_to "/", :notice => "Access Denied" unless current_user.try(:admin?)
    raise "AccessDenied" unless current_user.try(:admin?)
  end

  config.attr_accessible_role { :admin }
  # If your default_local is different from :en, uncomment the following 2 lines and set your default locale here:
  # require 'i18n'
  # I18n.default_locale = :de

  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, User

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, User

  # Set the admin name here (optional second array element will appear in a beautiful RailsAdmin red ©)
  config.main_app_name = ['All Seats', 'Admin']
  # or for a dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }


  #  ==> Global show view settings
  # Display empty fields in show views
  # config.compact_show_view = false

  #  ==> Global list view settings
  # Number of default rows per-page:
  # config.default_items_per_page = 20

  #  ==> Included models
  # Add all excluded models here:
  # config.excluded_models = [User]

  # Add models here if you want to go 'whitelist mode':
  # config.included_models = [User]

  # Application wide tried label methods for models' instances
  # config.label_methods << :description # Default is [:name, :title]

  #  ==> Global models configuration
  # config.models do
  #   # Configuration here will affect all included models in all scopes, handle with care!
  #
  #   list do
  #     # Configuration here will affect all included models in list sections (same for show, export, edit, update, create)
  #
  #     fields_of_type :date do
  #       # Configuration here will affect all date fields, in the list section, for all included models. See README for a comprehensive type list.
  #     end
  #   end
  # end
  #
  #  ==> Model specific configuration
  # Keep in mind that *all* configuration blocks are optional.
  # RailsAdmin will try his best to provide the best defaults for each section, for each field.
  # Try to override as few things as possible, in the most generic way. Try to avoid setting labels for models and attributes, use ActiveRecord I18n API instead.
  # Less code is better code!
  # config.model MyModel do
  #   # Cross-section field configuration
  #   object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #   label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #   label_plural 'My models'      # Same, plural
  #   weight -1                     # Navigation priority. Bigger is higher.
  #   parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #   navigation_label              # Sets dropdown entry's name in navigation. Only for parents!
  #   # Section specific configuration:
  #   list do
  #     filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #     items_per_page 100    # Override default_items_per_page
  #     sort_by :id           # Sort column (default is primary key)
  #     sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     # Here goes the fields configuration for the list view
  #   end
  # end

  # Your model's configuration, to help you get started:

  # All fields marked as 'hidden' won't be shown anywhere in the rails_admin unless you mark them as visible. (visible(true))

  # config.model User do
  #   # Found associations:
  #   # Found columns:
  #     configure :id, :integer
  #     configure :name, :string
  #     configure :admin, :boolean
  #     configure :created_at, :datetime
  #     configure :updated_at, :datetime
  #     configure :email, :string
  #     configure :password, :password         # Hidden
  #     configure :password_confirmation, :password         # Hidden
  #     configure :reset_password_token, :string         # Hidden
  #     configure :reset_password_sent_at, :datetime
  #     configure :remember_created_at, :datetime
  #     configure :sign_in_count, :integer
  #     configure :current_sign_in_at, :datetime
  #     configure :last_sign_in_at, :datetime
  #     configure :current_sign_in_ip, :string
  #     configure :last_sign_in_ip, :string   #   # Sections:
  #   list do; end
  #   export do; end
  #   show do; end
  #   edit do; end
  #   create do; end
  #   update do; end
  # end
  config.authorize_with :cancan

  config.model Category do
      field :id
      field :name
      field :slug
      field :meta_title
      field :meta_description
      field :h1
      field :description
      field :visible
      field :active
      field :image_path

      field :parent_id, :enum do
          enum do
            except = bindings[:object].id
            Category.where("id != ?", except).map { |c| [ c.name, c.id ] }
          end
      end

      fields :events
      fields :collections
      fields :performers
  end

  config.model ImportCsv do
    field :id
    field :output
    field :csv
    field :import_type, :enum do
      enum do
        ["events", "performers", "categories", "venues", "listings", "testimonials"]
      end
    end
  end


  config.model StaticPage do
    edit do
      field :name
      field :active
      field :include_left_sidebar
      field :include_right_sidebar
      field :title
      field :permalink
      field :content, :rich_editor do
        config({
          :insert_many => true
        })
      end
      field :meta_description
    end
  end


  config.model Event do
    field :id
    field :name
    field :slug
    field :category
    field :location
    field :date
    field :active
    field :featured
    field :clicks
    field :priority
    field :country_tnid
    field :img_interactive_url
    field :img_static_url
    field :is_womens
    field :state_province
    field :venue_configuration
    field :venue
    fields :performers
    field :description
    fields :listings
    fields :collections
    field :meta_title
    field :meta_description
    field :h1
    field :image_path
  end



  # config.actions do
  #   dashboard
  #   index
  #   new
  #   export
  #   history_index
  #   bulk_delete
  #   show
  #   edit
  #   delete
  #   history_show
  #   show_in_app

  #   import
  # end




end
