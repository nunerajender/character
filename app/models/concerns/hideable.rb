# More options and details: https://github.com/joecorcoran/hideable
module Hideable
  extend ActiveSupport::Concern

  included do
    field :hidden, type: Boolean, default: false

    scope :hidden,     -> { where(hidden: true)  }
    scope :not_hidden, -> { where(hidden: false) }

    def hidden?
      self.hidden
    end

    def hide!
      return if self.hidden?
      self.hidden = true
      self.save!
    end

    def unhide!
      return unless self.hidden?
      self.hidden = false
      self.save!
    end
  end
end