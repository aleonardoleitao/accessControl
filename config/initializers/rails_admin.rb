require 'i18n'
require "rails_admin/application_controller"

I18n.default_locale = :pt

RailsAdmin.config do |config|
  config.main_app_name = ["AccessControl"]

  config.authorize_with do |controller|
    unless current_user.try(:admin?)
      flash[:error] = "You are not an admin"
      redirect_to ("http://sexcrs.com/" + current_user.username)
    end
  end

  # Blacklist Approach to configure models
  # The excluded_models configuration above permits the blacklisting of individual model classes.
  # config.excluded_models = ["Class1"]

  # Whitelist Approach to configure models
  # If you prefer a whitelist approach, then you can use the included_models configuration option instead:
  config.included_models = ["ForbiddenWord", "User", "Profile", "CRS"]

  config.actions do
    # root actions
    dashboard                     # mandatory

    # collection actions
    index                         # mandatory
    new do
      except ["User"]
    end

    #export
    #history_index
    #bulk_delete

    # member actions
    show
    edit
    delete do
      except ["User"]
    end
    #history_show
    #show_in_app
  end
end
