module JsonObjectHelper
  def object_fields_to_include
    @object_fields_to_include ||= begin
      params[:fields_to_include] ? params[:fields_to_include].split(',') : []
    end
  end

  def object_fields
    @object_fields ||= begin
      result_fields = {}

      fields = model_class.fields.keys - %w( _id _type _position _keywords created_at updated_at deleted_at )


      # TODO: add a warning message here

      if params[:title_field]
        result_fields[:title_field] = params[:title_field]
      else
        if fields.size > 0
          result_fields[:title_field] = fields[0]
        else
          puts "WARNING: #{ model_class } model doesn't have any unique fields."
        end
      end


      if params[:meta_field]
        result_fields[:meta_field] = params[:meta_field]
      else
        if fields.size > 1
          result_fields[:meta_field] = fields[1]
        end
      end


      if model_class.method_defined? :character_thumb_url
        result_fields[:image_field] = :character_thumb_url
      end

      result_fields
    end
  end


  # IDEA: try to move the __title and __meta logic to the frontend model


  # This builds an object which is used as character internal
  # model in index view and headers.
  def build_json_object(o)
    # Until we don't have a format for requesting model attributes
    # use the first attribute of the model.

    # Here we exclude meta fields to have more chances to get
    # descriptive field for the admin index

    fields = object_fields
    hash   = { _id: o.id }

    if fields.has_key? :title_field
      hash[:__title] = o.try(fields[:title_field])
    end

    if fields.has_key? :meta_field
      hash[:__meta] = o.try(fields[:meta_field])
    end

    if fields.has_key? :image_field
      hash[:__image] = o.try(fields[:image_field])
    end

    object_fields_to_include.each do |f|
      hash[f] = o.try(f)
    end

    if params[:reorderable] == 'true'
      hash[:_position] = o.try(:_position)
    end

    if params[:extra_fields].present?
      params[:extra_fields].each do |extra_field|
        hash[extra_field] = o.try(extra_field)
      end
    end

    updated_at = o.try(:updated_at)
    if updated_at
      # TODO: add smart formatting options here
      hash[:__updated_at] = updated_at.to_formatted_s(:long_ordinal)
    end

    hash
  end
end
