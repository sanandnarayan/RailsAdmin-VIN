require "rails_admin_vin/engine"

module RailsAdminVin
end

require 'rails_admin/config/actions'

module RailsAdmin
  module Config
    module Actions
      class Vin < Base
        RailsAdmin::Config::Actions.register(self)


        register_instance_option :link_icon do
          'icon-refresh'
        end

        # Should the action be visible
        register_instance_option :visible? do
          true
        end

        register_instance_option :authorized? do
          true
        end

        # Is the action on a model scope (Example: /admin/team/export)
        register_instance_option :collection? do
          true
        end

        # This block is evaluated in the context of the controller when action is called
        # You can access:
        # - @objects if you're on a model scope
        # - @abstract_model & @model_config if you're on a model or object scope
        # - @object if you're on an object scope
        register_instance_option :controller do
          Proc.new do
            @abstract_model
            if request.method == "GET"
              if params[:vin]
                render text: "awesome"
              else
                render :action => @action.template_name
              end
            else
              v = Variant.new()
              v.vin_no = params[:vin]
              v.save()
              redirect_to "/admin/variant"
            end
          end
        end

        # Model scoped actions only. You will need to handle params[:bulk_ids] in controller
        register_instance_option :bulkable? do
          false
        end

        # View partial name (called in default :controller block)
        register_instance_option :template_name do
          key.to_sym
        end

        # For Cancan and the like
        register_instance_option :authorization_key do
          key.to_sym
        end

        # List of methods allowed. Note that you are responsible for correctly handling them in :controller block
        register_instance_option :http_methods do
          [:get, :post]
        end

        # Url fragment
        register_instance_option :route_fragment do
          custom_key.to_s
        end

        # Controller action name
        register_instance_option :action_name do
          custom_key.to_sym
        end

        # I18n key
        register_instance_option :i18n_key do
          key
        end

        # User should override only custom_key (action name and route fragment change, allows for duplicate actions)
        register_instance_option :custom_key do
          key
        end

        # Breadcrumb parent
        register_instance_option :breadcrumb_parent do
          case
          when root?
            [:dashboard]
          when collection?
            [:index, bindings[:abstract_model]]
          when member?
            [:show, bindings[:abstract_model], bindings[:object]]
          end
        end

        def key
          self.class.key
        end

        def self.key
          self.name.to_s.demodulize.underscore.to_sym
        end
      end
    end
  end
end
