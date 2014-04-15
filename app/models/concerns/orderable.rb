module Orderable
  extend ActiveSupport::Concern

  included do
    field :_position, type: Float, default: ->{ (self.class.all.first.try(:_position) || 1000) + 10 }
    default_scope -> { order_by(_position: :desc) }
  end
end