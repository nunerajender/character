module Character
  class Instance
    DEFAULT_NAME = 'admin'

    attr_accessor :name,
                  :title,
                  :user_model,

                  :permissions_filter,
                  :before_index,
                  :before_save,

                  :javascript_filename,
                  :stylesheet_filename,

                  :logo_image,
                  :login_background_image,
                  :development_auto_login

    def initialize(name = Instance::DEFAULT_NAME)
      @name                   = name.gsub(' ', '-').downcase
      @title                  = 'Character'
      @user_model             = 'Character::User'
      @logo_image             = 'rails.png'
      @login_background_image = 'http://images.nationalgeographic.com/exposure/core_media/ngphoto/image/68263_0_1040x660.jpg'
      @development_auto_login = false
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

    def default?
      @name == Instance::DEFAULT_NAME
    end
  end
end