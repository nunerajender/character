

@AppListItem = Backbone.Marionette.ItemView.extend
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
    # update link according to the current state
    @ui.link.attr('href', location.hash + "/edit/#{ @model.get('_id') }")

    # reordering helpers
    @$el.attr('data-id', @model.id)
    @$el.attr('data-position', @model.get('_position'))