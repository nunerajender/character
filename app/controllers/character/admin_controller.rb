# Author: Alexander Kravets
#         Slate, 2013

class Character::AdminController < ActionController::Base
  # Generic API for Character::Admin models

  layout false

  # Filters -----------------------------------------------

  before_filter :authenticate_admin_user

  def authenticate_admin_user
    @admin_user = browserid_current_user if browserid_authenticated?
  end


  # TODO: for api calls return 500 if user is not loggedin


  before_filter :set_model_class, except: %w( admin )
  # - sets model class to be used in actions, class name is defined
  #   in URL with a slag where - replaced by ::, for example:
  #   Character::BlogPost would be /api/Character-BlogPost/new

  def set_model_class
    # Generating class name from the url slug, where '::' replaced with '-'
    # For example: Character-Post -> Character::Post
    @model_slug  = params[:model_slug]
    @model_class = @model_slug.gsub('-', '::').constantize
    # model name is used while template rendering
    @model_name  = @model_slug.split('-').last.split(/(?=[A-Z])/).join(' ')
    # namespace is used while form processing
    @namespace   = @model_class.name.underscore.gsub('/', '_').to_sym
  end


  before_filter :set_form_template, only: %w( new edit create update ), except: %w( admin )
  # - this helper provides way to redefine defaults templates to be
  #   used for form-template based actions mentioned above

  def set_form_template
    template_folder = @model_class.name.underscore.to_s.pluralize

    if template_folder.start_with? 'character/'
      template_folder = 'character/' + template_folder.gsub('character/', '').gsub('/', '/admin/')
    else
      template_folder = 'character/admin/' + template_folder
    end

    puts "\n\n\n"
    puts template_folder
    puts "\n\n\n"

    # Check if there is a custom form template for the class in the
    # character/ folder, if not using generic form

    if template_exists?("form", template_folder, false)
      @form_template = "#{ template_folder }/form"
    else
      @form_template = "character/admin/generic_form"
    end
  end


  # Helpers -----------------------------------------------

  before_filter :set_form_fields, except: %w( admin )

  def set_form_fields
    @form_fields = @model_class.fields.keys - %w( _id _type created_at _position _keywords updated_at deleted_at )
  end


  before_filter :map_character_item_fields, except: %w( admin )

  def map_character_item_fields
    @character_item_fields = {}

    fields = @model_class.fields.keys - %w( _id _type _position _keywords created_at updated_at deleted_at )

    # TODO: add a warning message here
    if fields.size > 0
      @character_item_fields[:title_field] = fields[0]
    else
      puts "WARNING: #{ @model_class } model doesn't have any unique fields."
    end

    if fields.size > 1
      @character_item_fields[:meta_field] = fields[1]
    end

    if @model_class.method_defined? :character_thumb_url
      @character_item_fields[:image_field] = :character_thumb_url 
    end
  end


  # This builds an object which is used as character internal
  # model in index view and headers.
  def build_character_item(o)
    fields = @character_item_fields
    hash   = { _id: o.id }

    if fields.has_key? :title_field
      hash[:__title] = o.try(fields[:title_field])
    end

    if fields.has_key? :meta_field
      hash[:__meta] = o.try(fields[:meta_field])
    end
    
    if fields.has_key? :image_field
      hash[:__image] = o.try(fields[:image_field])
    end

    hash
  end


  # Actions -----------------------------------------------

  # - the index action implements search and paging functionality.
  #   IDEA: fields and template for index view could be defined in
  #         coffeescript admin file, where list of required fields
  #         is passed to the action as parameter.
  def index
    search_query  = params[:search_query] || ''
    page          = params[:page]         || 1
    per_page      = params[:per_page]     || 50

    @objects = @model_class.all

    @objects = @objects.full_text_search(search_query) if not search_query.empty?
    @objects = @objects.page(page).per(per_page)

    # TODO: here we should implement logic of objects transform to
    #       json list and check if all provided attribute names are
    #       available, if some is not available provide an error
    #       handler.


    # Until we don't have a format for requesting model attributes
    # use the first attribute of the model.

    # Here we exclude meta fields to have more chances to get
    # descriptive field for the admin index
    item_objects = @objects.map { |o| build_character_item(o) }

    render json: {  objects:       item_objects,
                    total_pages:   @objects.total_pages(),
                    page:          page,
                    per_page:      per_page,
                    search_query:  search_query }
  end


  def show
    # TODO: Add an option to render custom template if the one
    #       is defined in the app for the model.
    @object = @model_class.find(params[:id])
    render json: @object
  end


  # - right now form is build for the model automatically and
  #   all fields are using textinput.
  #   TODO: form should be autogenerated with smart field type
  #         inputs support.
  #   TODO: there should be a simple way to exclude or change
  #         type of fields in the autogenerated form, this could
  #         also work via coffeescript.
  def new
    @form_action_url = "/admin/#{ @model_slug }"
    @object = @model_class.new
    render @form_template
  end


  # - new action comment relates to edit action as well.
  def edit
    @object = @model_class.find(params[:id])
    @form_action_url = "/admin/#{ @model_slug }/#{ @object.id }"
    render @form_template
  end


  # TODO: support of multiple object creation.
  def create
    @object = @model_class.create params[@namespace]

    if @object.save
      render json: build_character_item(@object)
    else
      render @form_template
    end
  end


  def update
    # TODO: support of multiple object update

    @object = @model_class.find(params[:id])

    if @object.update_attributes params[@namespace]
      render json: build_character_item(@object)
    else
      render @form_template
    end
  end


  # TODO: support of multiple object delete.
  def destroy
    @object = @model_class.find(params[:id])
    @object.destroy
    render json: 'ok'
  end


  # Views -------------------------------------------------

  def admin
    render 'character/admin/index'
  end
end



