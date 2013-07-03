# Author: Alexander Kravets
# Slate Studio 2013

# Uses: 
#  - underscore
#  - underscore.string

@simple_form =
  get_date_values: (arr) ->
    date_fields = {}
    
    get_date_field = (el) ->
      if _.str.include(el.name, '(1i)')
        return { name: el.name.replace('(1i)', ''), value: el.value, type: 'year'  }
      
      else if _.str.include(el.name, '(2i)')
        return { name: el.name.replace('(2i)', ''), value: el.value, type: 'month' }

      else if _.str.include(el.name, '(3i)')
        return { name: el.name.replace('(3i)', ''), value: el.value, type: 'day'   }

      return false

    _.each arr, (element, index, list) ->
      field = get_date_field(element)
      if field
        date_fields[field.name] = {} if not date_fields[field.name]
        date_fields[field.name][field.type] = field.value

    result = []
    
    _.each date_fields, (value, key, list) ->
      result.push
        name:     key
        value:    "#{value.year}-#{value.month}-#{value.day}"
        required: false
        type:     "hidden"

    return result


