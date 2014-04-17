module Character::JsonObjectConcern
  extend ActiveSupport::Concern

  def object_fields
    @object_fields ||= begin
      @object_fields = []

      if params[:f]
        @object_fields = params[:f].split(',')
      else
        fields = model_class.fields.keys - %w( _id _type _position _keywords created_at updated_at deleted_at )

        @object_fields << fields[0] if fields.size > 0
        @object_fields << fields[1] if fields.size > 1
        @object_fields << :character_thumb_url if model_class.method_defined? :character_thumb_url
      end

      @object_fields << :_position if model_class.fields.keys.include? '_position'
      @object_fields << :hidden    if model_class.fields.keys.include? 'hidden'
      @object_fields << :created_at
      @object_fields << :updated_at

      @object_fields
    end
  end

  def build_json_object(o)
    hash = { _id: o.id.to_s }
    object_fields.each { |f| hash[f] = o.try(f) }
    hash
  end
end
