ForemanPluginTemplate::Engine.routes.draw do
  ##volumes
  get '/volumes' , :controller => 'volumes', :action => 'index'
  get 'volumes/new_volume' , :controller => 'volumes', :action => 'new_volume'
  get 'volumes/attach_volume', :controller => 'volumes', :action => 'attach_volume'
  get 'volumes/:id', :controller => 'volumes', :action => 'volume_info', as: :volume_info
  post 'volumes/new_snapshot/:id', :controller => 'snapshots', :action => 'new_snapshot', as: :new_snapshot
  post 'volumes/attach/:id', :controller => 'volumes', :action => 'attach_volume', as: :attach_volume
  post 'snapshots/new_volume/:snap_id', :controller => 'volumes', :action => 'new_volume_from_snapshot', as: :new_volume_from_snapshot
  post 'volumes/new_volume', :controller => 'volumes', :action => 'new_volume', as: :new_volume
  post 'volumes/:snap_id', :controller => 'volumes', :action => 'save_volume', as: :save_volume_from_snapshot
  post 'volumes', :controller => 'volumes', :action => 'save_volume', as: :save_volume
  post 'snapshots/attach/:id', :controller => 'volumes', :action => 'attach' , as: :attach
  post 'volumes/detach/:id' , :controller => 'volumes', :action => 'detach' , as: :detach
  post 'volumes/detach_volume/:id' , :controller => 'volumes', :action => 'detach_volume', as: :detach_volume

  # ##snapshots
  get '/snapshots', :controller => 'snapshots', :action => 'index'
  #get 'snapshots/new_snapshot', :controller => 'snapshots', :action => 'new_snapshot'
  get 'snapshots/snapshot_info/:snap_id', :controller => 'snapshots', :action => 'snapshot_info', as: :snapshot_info
  get 'snapshots/delete_snapshot', :controller => 'snapshots', :action => 'delete_snapshot'
  post 'snapshots/snapshot_info/:id', :controller => 'snapshots', :action => 'save_snapshot', as: :save_snapshot
  post 'snapshots/delete_snapshot/:snap_id', :controller => 'snapshots', :action => 'delete_snapshot', as: :delete_snapshot
end

 Foreman::Application.routes.draw do
   mount ForemanPluginTemplate::Engine, at: '/foreman_plugin_template'
 end
