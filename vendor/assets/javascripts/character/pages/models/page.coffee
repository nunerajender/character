class Character.Pages.Page extends Backbone.Model
  idAttribute:  '_id'

  update_attributes: [
    'title',
    'permalink',
    'html',
    'menu',
    'keywords',
    'description',
    'published',
    'featured_image_id' ]

  toJSON: ->
    attributes = {}
    attributes[a] = @get(a) for a in @update_attributes
    return { character_page: attributes }

  state: ->
    if @get 'published' then 'Published' else 'Hidden'

  menu_or_title: ->
    menu = @get 'menu'
    if menu then return menu else return @get 'title'

