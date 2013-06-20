module Character
  class Engine < ::Rails::Engine
    config.before_configuration do
      
      # BrowserID configuration and setup
      # TODO: revise after devise is integrated
      
      config.browserid.user_model   = "Character::AdminUser"
      config.browserid.login.text   = 'Sign-in with Persona'
      config.browserid.login.path   = '/admin/login'
      config.browserid.logout.path  = '/admin/logout'

      config.character_admin_models = []
    end

    # Here we are forcing model classes to be defined when app starts
    # to have an access to the in the admin
    config.after_initialize do
      if not ::Rails.application.config.cache_classes
        Rails.application.eager_load!
      end
    end
  end
end