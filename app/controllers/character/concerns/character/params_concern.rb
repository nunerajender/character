module Character::ParamsConcern
  extend ActiveSupport::Concern

  private

  # this hack allows to permit for mass assigment everything that
  # is sent with a form, with hashs it only goes 1 level deep.
  def permit_params
    permit_fields = []
    params[form_attributes_namespace].each do |key, value|
      if value.is_a?(Hash)
        h = {} ; h[key] = value.keys
        permit_fields << h
      else
        permit_fields << key
      end
    end

    params.require(form_attributes_namespace).permit(permit_fields)
  end

  # this goes only one level deep
  def permit_api_params
    params.require('api').permit(params['api'].keys)
  end
end