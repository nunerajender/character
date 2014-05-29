module WebsiteSettings
  extend ActiveSupport::Concern

  included do
    before_filter :set_website_settings

    def set_website_settings
      @domain      = ::Settings.value("Website::Domain")
      @title       = ::Settings.value("Website::Title")
      @description = ::Settings.value("Website::Description")
      @ga_id       = ::Settings.value("Website::Google Analytics ID")
      @ga_domain   = @domain.gsub('www.', '')

      @header_html = ::Settings.value("Layout::Header")
      @footer_html = ::Settings.value("Layout::Footer")
    end
  end
end
