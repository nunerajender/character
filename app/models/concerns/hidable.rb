module Hidable
  extend ActiveSupport::Concern

  included do
    field :hidden, type: Boolean, default: false

    scope :public,  -> { where(hidden: false) }
    scope :private, -> { where(hidden: true)  }
    scope :hidden,  -> { where(hidden: true)  }
  end
end