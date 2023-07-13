class ForemanPluginTemplate::VolumesController < ApplicationController
  def index
    volume = ForemanPluginTemplate::DiskManagement.new
    @volumes = volume.list_volumes() 
    render 'volumes/index'
  end

  def volume_info
    volume = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    @info = volume.show_volume_info(@vol)
    @snapshots = volume.list_snapshot(@vol)
    puts @snapshots
    render 'volumes/volume_info'
  end

  def new_volume_from_snapshot
    @snap = params[:snap_id]
    render 'volumes/new_volume_from_snapshot'
  end

  def new_volume
    render 'volumes/new_volume'
  end

  def save_volume
    volume = ForemanPluginTemplate::DiskManagement.new
    @snap = params[:snap_id]
    required = [:name, :description, :zone, :type, :size]
    form_complete = true
    required.each do |f|
      if params.has_key? f and params[f].blank?
        form_complete = false
      end
    end
    if form_complete
      @vol_id=volume.create_volume(params[:name], params[:description],
         params[:zone], params[:attach], params[:type], params[:size], @snap )
      redirect_to volume_info_path(:id => @vol_id)
    else
      flash.alert = "Complete all the fields."
      render 'volumes/new_volume'
    end
  end

  def attach_volume
    volume = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    @servers = volume.list_servers()
    render 'volumes/attach_volume'
  end

  def attach
    volume = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    @device = params[:device]
    @server = params[:server]
    @volu = params[:volume]
    puts @volu
    @response = volume.attach_volume(@server,@vol,@device)
    puts 'attached'
  end

  def detach
    volume = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    @response = volume.detach_volume(@vol)
    flash.alert = "volume detached"
    redirect_to volume_info_path(:id => @vol)
  end
end