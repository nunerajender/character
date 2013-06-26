module Character::Admin
  extend ActiveSupport::Concern


  def admin_form_config
    slug  = self.class.name.gsub('::', '-')
    url   = "/character/api/#{ slug }"

    if self.persisted?
      url += "/#{ self.id }"
    end

    { fields: self.class.admin_editable_fields,
      url:    url }
  end


  def as_json(options={})
    if options.has_key?(:methods)
      options[:methods] += self.class.admin_json_methods
    else
      options[:methods] = self.class.admin_json_methods
    end
    options[:methods].uniq!
    super(options)
  end


  included do
    # Add class to the admin
    if not ::Rails.application.config.character_admin_models.include?(self.name)
      ::Rails.application.config.character_admin_models << self.name
    end

    if self.method_defined? :created_at
      def formatted_created_at
        'Created at ' + created_at.strftime('%b %d, %Y') if created_at
      end
    end
  end


  module ClassMethods
    def admin_title
      self.name.split('::').last().pluralize.scan(/[A-Z][^A-Z]*/).join(' ')
    end


    def admin_editable_fields
      # exclude these fields from the auto generated form
      self.fields.keys - %w( _id _type created_at _position _keywords updated_at deleted_at )
    end


    def admin_reorderable?
      # There is a module Mongoid:Reorderable to be included in the mongo model,
      # this module adds _position field to identify object position in the list.
      fields.keys.include?('_position') ? true : false
    end


    def admin_searchable?
      # There is a module Mongoid:Search to be included in the mongo model,
      # this module adds _keywords field to store searchable terms.
      fields.keys.include?('_keywords') ? true : false
    end


    def admin_json_methods
      methods = admin_item_options.values
      methods << :admin_thumb_url       if self.method_defined? :admin_thumb_url
      methods << :formatted_created_at  if self.method_defined? :formatted_created_at
      methods.uniq
    end


    def admin_item_options
      hash    = {}

      fields  = admin_editable_fields
      hash[:line1_left]  = fields[0]
      hash[:line2_left]  = fields[1] if fields.size > 1
      hash[:line1_right] = fields[2] if fields.size > 2

      hash[:line1_right] = :formatted_created_at if self.method_defined? :formatted_created_at
      hash[:image_url]   = :admin_thumb_url      if self.method_defined? :admin_thumb_url

      hash
    end


    def admin_paginate
      true
    end


    def admin_config
      { model_name:           self.name,
        title:                self.admin_title,
        reorderable:          self.admin_reorderable?,
        searchable:           self.admin_searchable?,
        render_item_options:  self.admin_item_options,
        paginate:             self.admin_paginate }
    end
  end
end