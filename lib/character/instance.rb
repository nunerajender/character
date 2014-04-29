module Character
  class Instance
    DEFAULT_NAME = 'admin'

    attr_accessor :name,
                  :title,
                  :user_model,

                  :before_index,
                  :before_save,

                  :javascript_filename,
                  :stylesheet_filename,

                  :development_auto_login,
                  :force_ssl,

                  # defined in config/settings.yml
                  :settings,
                  :logo,
                  :login_background

    def initialize(name = Instance::DEFAULT_NAME)
      @name                   = name.gsub(' ', '-').downcase
      @title                  = 'Character'
      @user_model             = 'Character::User'
      @development_auto_login = false
      @force_ssl              = true
    end

    def title
      @title || @name.humanize
    end

    def javascript_filename
      @javascript_filename || @name
    end

    def stylesheet_filename
      @stylesheet_filename || @name
    end

    def user_class
      @user_class ||= @user_model.constantize
    end

    def settings
      @settings ||= ::Settings.group(@name.capitalize + ' Settings')
    end

    def logo
      @logo ||= settings['Logo'].value
    end

    def login_background
      @login_background ||= settings['Login Background'].value
    end
  end
end