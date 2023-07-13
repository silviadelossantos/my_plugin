module ForemanPluginTemplate
  module HostsHelperExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    # create or overwrite instance methods...
    def instance_method_name
    end
    def links_host_overview_fields(host)
      fields = []
      fields << { :field => [_("Build duration"), build_duration(host)], :priority => 90 } # call to other helper method
      fields << { :field => [_("Operating System"), link_to(host.operatingsystem.to_label, hosts_path(:search => "os_description = #{host.operatingsystem.description}"))], :priority => 800 } # creating a linkable item
      fields << { :field => [_("PXE Loader"), host.pxe_loader], :priority => 900 } # adding a simple value
  
      fields
  end
  end
end
