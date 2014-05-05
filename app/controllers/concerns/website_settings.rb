module WebsiteSettings
  extend ActiveSupport::Concern

  included do
    before_filter :set_website_settings

    def set_website_settings
      settings     = ::Settings.group('Website Settings')
      @domain      = settings['Domain'].value
      @title       = settings['Title'].value
      @description = settings['Description'].value
      @ga_id       = settings['Google Analytics ID'].value
      @ga_domain   = @domain.gsub('www.', '')
    end
  end
end