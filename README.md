# Character Rails Admin

Have you heard of [Django](https://www.djangoproject.com/), [Wordpress](https://wordpress.org/), [Active Admin](http://activeadmin.info/), [Locomotive](http://locomotivecms.com/)? Yeah?! — Those are all awesome... and **Character** is BETTER!

![Character Image](http://character.s3.amazonaws.com/character1.jpg)

## TODO

* Enable published/unpublished option for new posts (now post is published after first save);
* Fix paste code issue for redactor.js + chrome (this is pain in the ass);
* Add smart toolbar buttons customization for redactor.js;
* Add JS validation on form save;
* Fix focus jump after image insert / link edit in redactor.js;
* redactor.js source view is too big in height;
* redactor.js source view removes new lines from code;
* fix upload icon while uploading;
* fix default styles for blog: links do break words;
* SVG icons do not work for Firefox;
* Add menu groups option to make one icon in menu for group of models (apps);
* Add expand button to details header;
* Reset validation after succesful form submission;
* Cache list all list views in DOM and save scrolling state for them, rerender only details;
* Fix fontawesome for firefox;

## Setup new [Rails 4.1](http://rubyonrails.org) project

    rails new ProjectName -T -O

Add gems to the ```Gemfile```:

    # Mongoid ORM + Character
    gem 'carrierwave-mongoid', github: 'carrierwaveuploader/carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'character'

Run bundle and run generators:

    bundle ; rails g mongoid:config ; rails g character:bootstrap

## Routes

After character generator finishes it's dirty business, in ```/config/routes.rb``` you see:

    mount_character_instance 'admin'

This mounts character instance **admin** to ```/admin``` path and make character app accessible there. There are also two optional helpers ```mount_posts_at``` and ```mount_pages_at```, they mount default controllers to routes as well. Remove them if no need in **posts** or **pages** app.

Instance name **admin** could be changed, and you can use something different. This option is here for the case when a few character instances are required.

- mount_character_instance
- mount_posts_at
- mount_pages_at


## Running Automated Tests

`$ bundle exec rake test`


## Modules

- chr.genericModule()
- chr.postsModule()
- chr.pagesModule()
- chr.settingsModule()
- chr.settingsWebsite()
- chr.settingsPostCategories()
- chr.settingsAdmins()
- chr.settingsRedirects()


## Forms

To have custom form implementation for model, create ```form.html``` in ```/app/views/admin/model_names/``` — replace *model_names* with pluralized models name and if needed character instance name *admin* (default).

### Generic form template

Generic form template looks like this:

    <%= simple_form_for @object, url: @form_action_url, method: :post do |f| %>
      <%= f.input :name %>
    <% end %>

Checkout [Simple Form](https://github.com/plataformatec/simple_form) reference for all options (there are tons of them) which are available here.

**No need to include SUBMIT button in form!**

### Hideable

If you want to make model hideable include ```include Hideable``` in model and add hidden field to your form:

    <%= f.input :hidden, as: :hidden %>

This will add an eye button trigger in the admin header, which allows to switch state for model.

### Inline forms

Form inline elements could be added with this code (images example):

    <div class='chr-form-nested chr-form-nested-images sortable-list'>
      <%= f.fields_for :images do |ff| %>
        <%= ff.link_to_remove "Remove" %>
        <%= image_tag ff.object.image.small.url %>
        <%= ff.input :title, placeholder: 'Image title' %>
        <%= ff.input :image %>
        <%= ff.input :_position, as: :hidden %>
      <% end %>
      <%= f.link_to_add "Add an Image", :images %>
    </div>

- This template is based on [Nested Forms](https://github.com/ryanb/nested_form) gem by Ryan Bates, checkout docs for implementation details.
- Including ```sortable-list``` class and ```<%= ff.input :_position, as: :hidden %>``` make inline objects reorderable.
- This example uses ```chr-form-nested-images``` class for layout styling.


## Models

- Character::Post
- Character::PostCategory
- Character::Page
- Character::Image
- Character::Settings::Variable
- Character::User
- Character::Redirect


## Concerns

- UpdatedAgo
- CreatedAgo
- Orderable
- Hideable


## Helpers

- Character::SitemapGeneratorHelper


## Shortcuts

- CMD+s — save changes
- CMD+e — toggle fullscreen


## API

**[Character.Generic.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/generic/details.coffee) and [Character.Settings.DetailsView](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/settings/details.coffee)**

These are blank methods that could be overriden to extend view functionality. Example of ```Character.Generic.DetailsView``` override: [character/posts/module.coffee](https://github.com/slate-studio/character/blob/master/app/assets/javascripts/character/posts/module.coffee)

- @beforeContentRequest()
- @beforeRenderContent()
- @beforeFormHelpersStart()
- @afterRenderContent()
- @beforeSave()
- @beforeFormSubmit(arr, $form, options)
- @afterFormSubmitSuccess(responseText, statusText, xhr, $form)
- @beforeOnClose()
- @afterOnClose()


## Instances

Initializers for different instances are in ```config/initializers/character.rb```:

    Character.configure do |config|
      config.title = 'Project Title | Admin'
    end

Options:

- @title                  = 'Character'
- @user_model             = 'Character::User'
- @development_auto_login = false
- @force_ssl              = true

## Analytics

* Create a new project (```GA_APP_NAME```) at: [https://console.developers.google.com/project](https://console.developers.google.com/project)
* Enable Analytics under **APIs & auth** -> **APIs** -> Analytics API
* Create another client under **Credentials**
* Download and put **key-file** (```GA_KEY_FILE_NAME```) to your projects ```config``` folder
* Go to you (Analytics)[www.google.com/analytics] account and add the **Service account** email address to your account (```GA_SERVICE_ACCOUNT_EMAIL```). It should be something like ```something-long@developer.gserviceaccount.com```.

Set all variables in server environment:

- ```GA_APP_NAME```
- ```GA_SERVICE_ACCOUNT_EMAIL```
- ```GA_KEY_FILE_NAME```
- ```GA_PROFILE_ID```


## Settings


## Reports

(to be continued...)


## Redirects

Redirects app allows to quickly setup 301/302 redirects for the website.
