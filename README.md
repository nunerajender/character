## Character (α)

**IN DEVELOPMENT**

Data management framework based on [Backbone.js](http://backbonejs.org/) & [Marionette.js](https://github.com/marionettejs/backbone.marionette) written in CoffeeScript, using [Rails Framework](http://rubyonrails.org/) on the backend. Main goal to create easy to use set of development tools to empower administration applications with a clean and simple user interfaces.

![Character Demo](https://raw.github.com/slate-studio/character/master/doc/img/demo-1.jpg)


### Installation





## Configuration

Following two cofiguration files have to be created:

```/app/assets/javascript/character.coffee``` - Character modules configuration.

    #= require character/main
    #= require_self

```/app/assets/stylesheets/character.scss``` - Character styles.

    @import "character/main";


To add model to the character add following lines in ```/app/assets/javascript/character.coffee```:

    character.add_module
      name: 'Model_1'
      icon: 'rocket'

    character.add_module
      name: 'Model_2'
      icon: 'bolt'

    character.add_module 'Model_3'

Where ```Model_#``` are names of rails models.







## Using Custom Forms

Generic form could be overriden by custom form template which should be put to ```/app/views/character/module_name/model_name/form.html.erb``` or ```/app/views/character/model_name/form.html.erb```. Where ```module_name``` (optional) and ```model_name``` are names of the model to override form for.

Here is a generic template which is a good starting point for template customization:

    <%= simple_form_for @object, url: @form_action_url do |f| %>
      
      <div class='row chr-row-border'>
        
        <div class='small-12 columns'> 
          <h5><%= @model_name %> <small>attributes</small></h5>
        </div>

        <% @form_fields.each do |name| %>

          <%= f.input name, wrapper_class: 'small-12 columns' %>

        <% end %>  
      </div>

      <div class='row'>
        <div class='small-12 columns'>
          <%= f.button :submit, class: 'chr-btn-submit radius secondary' %>      
        </div>
      </div>
    <% end %>









## Foundation usage

At this point all basic layout is using custom style and colors. Foundation is used for menu (mobile) and rendering forms.









## TODOs & Improvements

. implement pagination interface in the generic app

. search option

. scopes

. add hotkeys for fast navigation

. collection is rendered twice for some reason

. replace topnav with original menu version







