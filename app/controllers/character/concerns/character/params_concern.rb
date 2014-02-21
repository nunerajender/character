module Character::ParamsConcern
  extend ActiveSupport::Concern

  private

  def attr_name_or_map(attr_name, val)
    # RECURSION is used to map all hashes in params to update nested documents
    if val.is_a?(Hash)
      map = {} ; map[attr_name] = []
      val.each { |hsh_key, hsh_value| map[attr_name] << attr_name_or_map(hsh_key, hsh_value) }
      return map
    else
      return attr_name
    end
  end

  def permit_params(namespace='api')
    permit_fields = []
    params[namespace].each { |key, value| permit_fields << attr_name_or_map(key, value) }
    params.require(namespace).permit(permit_fields)
  end
end