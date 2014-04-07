module CreatedAgo
  extend ActiveSupport::Concern

  included do
    include Mongoid::Timestamps
    include ActionView::Helpers::DateHelper

    def created_ago
      created_at ? "submitted #{time_ago_in_words(created_at)} ago" : ''
    end
  end
end