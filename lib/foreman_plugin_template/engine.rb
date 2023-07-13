module ForemanPluginTemplate
  class Engine < ::Rails::Engine
    isolate_namespace ForemanPluginTemplate
    engine_name 'foreman__plugin_template'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/views"]
    config.autoload_paths += Dir["#{config.root}/app/lib"]
    config.autoload_paths += Dir["#{config.root}/app/controllers"]

    # Add any db migrations
    initializer 'foreman__plugin_template.load_app_instance_data' do |app|
      ForemanPluginTemplate::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman__plugin_template.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman__plugin_template do
        requires_foreman '>= 2.4.0'

        describe_host do
          overview_fields_provider :links_host_overview_fields
        end
        # Add Global files for extending foreman-core components and routes
        #register_global_js_file 'global'

        #Add permissions
        security_block :foreman__plugin_template do
          permission :view_foreman__plugin_template, { :'foreman__plugin_template/example' => [:new_action],
                                                      :'react' => [:index] }
          #permission :view_something,  {:snapshots => [:index] }
        end

        # # Add a new role called 'Discovery' if it doesn't exist
         role 'ForemanDiskManagementPlugin', [:view_foreman__plugin_template]

        #add menu entry
        sub_menu :top_menu, :plugin_template, icon: 'pficon pficon-enterprise', caption: N_('Volume'), after: :hosts_menu do
        menu :top_menu, :volumes, caption: N_('Volumes'), engine: ForemanPluginTemplate::Engine
        menu :top_menu, :snapshots, caption: N_('Snapshot'), engine: ForemanPluginTemplate::Engine
        end

        #  menu :top_menu, :snapshots, engine: ForemanPluginTemplate::Engine,
        #  :caption=> N_('snapshot'),
        #  :parent => :hosts_menu, 
        #  :after => architectures,
        #  :first => false

        # add dashboard widget
        widget 'foreman__plugin_template_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do

      

      begin
        Host::Managed.send(:include, ForemanPluginTemplate::HostExtensions)
        HostsHelper.send(:include, ForemanPluginTemplate::HostsHelperExtensions)
        Facets.register(DiskManagementFacet) do
          tabs_hash = {
            :diskclasses => 'facets/disk_management_facet.html.erb' 
          }
      
          add_tabs tabs_hash 
        end
      rescue => e
        Rails.logger.warn "ForemanPluginTemplate: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanPluginTemplate::Engine.load_seed
      end
    end

    initializer 'foreman__plugin_template.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman__plugin_template'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
