# Character

**Character** is data management framework based on Backbone & Marionette written in CoffeeScript and backed with Rails.


## Configuration

To add model to the character add following lines in ```/app/assets/javascript/character.coffee```:

    #= require character/main
    #= require_self

    $ ->
        character.add_module 'Model_1'
        character.add_module 'Model_2'
        character.add_module 'Model_3'
        character.start()

Where ```Model_#``` are names of rails models.

## Foundation usage

At this point all basic layout is using custom style and colors. Foundation is used for menu (mobile) and rendering forms.


## TODOs & Improvements

. replace topnav with original menu version
. add default logo for details placeholder
. reorder items option
. search option
. scopes
. make headers meta to show updated at value if available
. update button style to be more clean
. use some nice pictures for login screen