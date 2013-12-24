# Author: Alexander Kravets
#         Slate, 2013

class Character::ApiController < ActionController::Base
  include InstanceHelper
  include ModelClassHelper
  include TemplatesHelper
  include JsonObjectHelper

  include AuthHelper
  before_filter :authenticate_user

  layout :false


  # Actions -----------------------------------------------

  # - the index action implements order+filtering, search and paging
  def index
    order_by     = params[:o]
    search_query = params[:q]  || ''
    page         = params[:p]  || 1
    per_page     = params[:pp] || 25

    @objects = model_class.unscoped.all

    # filter with where
    scopes = params.keys.select { |s| s.starts_with? 'where__' }
    scopes.each do |s|
      field_name = s.gsub('where__', '')

      filters = {}
      filters_list = params[s].split(',')

      if params[s].include? ':'
        params[s].split(',').each do |f|
          filters[ f.split(':').first ] = f.split(':').last
        end

        @objects = @objects.where( field_name => filters )
      else
        @objects = @objects.where( field_name => params[s] )
      end
    end



    # search option
    if not search_query.empty?
      @objects = @objects.full_text_search(search_query, match: :all)
    end



    # order_by format: &order_by=field_name:direction,field_name2:direction,...&
    if order_by
      filters = {}
      order_by.split(',').each do |filter|
        filter_options = filter.split(':')
        filters[filter_options.first] = filter_options.last
        object_fields.append(filter_options.first)
      end

      @objects = @objects.order_by(filters)
    end



    # TODO: generalize such callbacks and put them to the instance helper
    # instance callback defined in initializer
    if character_instance.before_index
      instance_exec &character_instance.before_index
    end



    # pagination
    @objects = @objects.page(page).per(per_page)



    # result
    item_objects = @objects.map { |o| build_json_object(o) }
    render json: item_objects
  end


  def show
    # TODO: Add an option to render custom template if the one
    #       is defined in the app for the model.
    @object = model_class.find(params[:id])
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
    @object = model_class.new
    render form_template
  end


  # - new action comment relates to edit action as well.
  def edit
    @object = model_class.find(params[:id])
    render form_template
  end


  # TODO: support of multiple object creation.
  def create
    @object = model_class.new params[form_attributes_namespace]

    if character_instance.before_save
      instance_exec &character_instance.before_save
    end

    if @object.save
      render json: build_json_object(@object)
    else
      # TODO: check if we need form_action_url and model_name here
      render form_template
    end
  end


  def update
    # TODO: support of multiple object update

    @object = model_class.find(params[:id])
    @object.assign_attributes params[form_attributes_namespace]

    if character_instance.before_save
      instance_exec &character_instance.before_save
    end

    if @object.save
      render json: build_json_object(@object)
    else
      # TODO: check if we need form_action_url and model_name here
      render form_template
    end
  end


  # TODO: support of multiple object delete.
  def destroy
    @object = model_class.find(params[:id])
    @object.destroy
    render json: 'ok'
  end

  private

  def authenticate_user
    if not auto_login!
      if browserid_authenticated? then login! else render status: :unauthorized, json: { error: "Access denied." } end
    end
  end
end