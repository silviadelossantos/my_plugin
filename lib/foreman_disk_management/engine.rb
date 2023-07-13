module ForemanPluginTemplate
  class Engine < ::Rails::Engine
    isolate_namespace ForemanPluginTemplate
    engine_name 'foreman_disk_management'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]
    config.autoload_paths += Dir["#{config.root}/app/views"]
    config.autoload_paths += Dir["#{config.root}/app/lib"]
    config.autoload_paths += Dir["#{config.root}/app/controllers"]

    # Add any db migrations
    initializer 'foreman_disk_management.load_app_instance_data' do |app|
      ForemanPluginTemplate::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_disk_management.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_disk_management do
        requires_foreman '>= 2.4.0'

        describe_host do
          overview_fields_provider :links_host_overview_fields
        end
        # Add Global files for extending foreman-core components and routes
        #register_global_js_file 'global'

        #Add permissions
        security_block :foreman_disk_management do
          permission :view_foreman_disk_management, { :'foreman_disk_management/example' => [:new_action],
                                                      :'react' => [:index] }
          #permission :view_something,  {:snapshots => [:index] }
        end

        # # Add a new role called 'Discovery' if it doesn't exist
         role 'ForemanDiskManagementPlugin', [:view_foreman_disk_management]

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
        widget 'foreman_disk_management_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
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

    initializer 'foreman_disk_management.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_disk_management'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
