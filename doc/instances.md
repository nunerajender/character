## Instances

Instances allow you to use several independent admins for one website. Each of them will be using separate configuration, styles and templates.

### Configuration

Example of configuration for two character instances, this must be included in `config/initializers` folder.

```ruby
Character.configure do |config|
  config.instance 'producers' do |instance|
    instance.title      = 'Producer Cabinet'
    instance.user_model = 'Producer'

    instance.permissions_filter = proc do
      %w(Producer Videos).include? model_class.name
    end
  end

  config.instance 'admin' do |instance|
    instance.title = 'Admin'
  end
end
```

List of all available options.

| Option                   | Description                   | Default   |
| ------------------------ | ----------------------------- | --------- |
| title                    | Title of the instance         |           |
| user_model               | Model to authenticate users, must be [browserid](https://github.com/alexkravets/browserid-auth-rails) compatible | Character::User |
| javascript_filename      | JavaScript configuration file | Name of instance |
| stylesheet_filename      | Stylesheet file               | Name of instance |
| logo_image               | See main doc for details      |           |
| login_background_image   | See main doc for details      |           |

### Templates

Each instance has its own templates. They must live under `character/#{ instance name }` folder. E.g. under `character/admin` & `character/producers` for configuration from "Configuration" section.