@Character.App ||= {}
@Character.App.ListEmtpyView = Backbone.Marionette.ItemView.extend
  template: -> """<div class='empty'>No items found</div>"""