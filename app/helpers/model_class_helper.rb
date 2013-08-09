module ModelClassHelper
  def model_slug
    @model_slug ||= begin
      params[:model_slug]
    end
  end


  # model class to be used in actions, class name is defined
  # in URL with a slag where - replaced by ::
  # e.g. Character::BlogPost would be /api/Character-BlogPost/new
  def model_class
    @model_class ||= begin
      model_slug.gsub('-', '::').constantize
    end
  end


  # model name is used while template rendering
  def model_name
    @model_name ||= begin
      model_slug.split('-').last.split(/(?=[A-Z])/).join(' ')
    end
  end


  # form_attributes_namespace is used while form processing
  def form_attributes_namespace
    @form_attributes_namespace ||= begin
      model_class.name.underscore.gsub('/', '_').to_sym
    end
  end
end
