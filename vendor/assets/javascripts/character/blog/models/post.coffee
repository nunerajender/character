class Character.Blog.Post extends Backbone.Model
  idAttribute:  '_id'

  update_attributes: [
    'title',
    'slug',
    'md',
    'html',
    'date',
    'tags',
    'excerpt',
    'category_id',
    'published',
    'featured_image_id',
    'featured' ]


  toJSON: ->
    attributes = {}
    attributes[a] = @get(a) for a in @update_attributes
    return { character_post: attributes }


  state: ->
    if @get 'published'
      if @get 'featured'
        return 'Published + Featured'
      else
        return 'Published'
    return 'Draft'


  date_published: ->
    date = @get 'date'
    if date then moment(date, "YYYY-MM-DD").format('MMM D, YYYY') else ''


  date_or_state: ->
    if @get 'published'
      if @get 'featured'
        return 'Featured'
      return @date_published()
    return 'Draft'


