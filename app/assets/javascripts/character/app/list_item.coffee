@Character.App ||= {}
@Character.App.ListItemView = Backbone.Marionette.ItemView.extend
  tagName:   'li'
  className: 'chr-app-list-item'

  template: (item) ->  """<a title='#{ item.__title }'>
                            <img src='#{ item.__image }' />
                            <div class='container'>
                              <strong class='title'>#{ item.__title }</strong>
                              <span class='meta'>#{ item.__meta }</span>
                            </div>
                          </a>"""

  modelEvents:
    'change':  'render'
    'destroy': 'remove'

  ui:
    link: 'a'

  onRender: ->
    @$el.addClass('has-thumbnail') if @model.getImage()
    @ui.link.attr('href', "#/#{ chr.path }/edit/#{ @model.id }")

    @$el.attr('data-id', @model.id)
    @$el.attr('data-position', @model.getPosition())