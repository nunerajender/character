module UpdatedAgo
  extend ActiveSupport::Concern

  included do
    include ActionView::Helpers::DateHelper

    def updated_ago
      "updated #{time_ago_in_words(updated_at)} ago"
    end
  end
end
