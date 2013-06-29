# Character

**Character** is data management framework based on Backbone & Marionette written in CoffeeScript and backed with Rails.


## Configuration

To add model to the character add following lines in ```/app/assets/javascript/character.coffee```:

    #= require character/main
    #= require_self

    character.add_module
      name: 'Model_1'
      icon: 'rocket'

    character.add_module
      name: 'Model_2'
      icon: 'bolt'

    character.add_module 'Model_3'

Where ```Model_#``` are names of rails models.

## Foundation usage

At this point all basic layout is using custom style and colors. Foundation is used for menu (mobile) and rendering forms.


## TODOs & Improvements

. fix: new item should appear on top / fix the real position

. limit access to api

. figure out how to position new item in the scoped view


. add loader spinner for form update (ladda by hakimel)

. replace topnav with original menu version

. add default logo for details placeholder

. reorder items option

. search option

. scopes

. make headers meta to show updated at value if available

. add hotkeys for fast navigation

. when create new object, split submit button into two: create + next | create + close

