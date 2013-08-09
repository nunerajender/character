## Namespaces

Namespaces allow you to use several independent admins for one website. Each of them will be using separate configuration, styles and templates.

### Configuration

Example of configuration for two admins. It must live under your `config/initializers` folder.

```ruby
Character.configure do |config|
  config.namespace 'producers' do |namespace|
    namespace.title      = 'Producer Cabinet'
    namespace.user_model = 'Producer'

    namespace.permissions_filter = proc do
      %w(Producer Videos).include? @model_class.name
    end
  end

  config.namespace 'admin' do |namespace|
    namespace.title = 'Admin'
    namespace.no_auth_on_development = true
  end
end
```

List of all available options.

| Option                   | Description                   | Default   |
| ------------------------ | ----------------------------- | --------- |
| title                    | Title of admin                |           |
| user_model               | Model to authenticate users, must be [browserid](https://github.com/mvxcvi/browserid-rails) compatible | Character::AdminUser |
| permissions_filter       | lambda function to restrict permissions. Must return boolean value. It is runned each time when api call is code. It is executed in controller context, so `request`, `params`, `@model_class` can be used to decide if allow request. | |
| javascript_filename      | JavaScript configuration file | Name of namespace |
| stylesheet_filename      | Stylesheet file               | Name of namespace |
| company_logo_image       | See main doc for details      |           |
| login_background_image   | See main doc for details      |           |
| no_auth_on_development   | See main doc for details      |           |

