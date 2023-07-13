#require 'aplication_controller'
class ForemanPluginTemplate::SnapshotsController < ApplicationController
  def index
    snapshot = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    @snapshots = snapshot.list_snapshot(@vol)
    render 'snapshots/index'
  end

  def snapshot_info
    snapshot = ForemanPluginTemplate::DiskManagement.new
    @snap = params[:snap_id]
    @info =snapshot.show_snapshot_info(@snap)
     puts  @info
    render 'snapshots/snapshot_info'
  end

  def new_snapshot
    @vol = params[:id]
    render 'snapshots/new_snapshot'
  end

  def save_snapshot
    snapshot = ForemanPluginTemplate::DiskManagement.new
    @vol = params[:id]
    required = [:name, :description]
    form_complete = true
    required.each do |f|
      if params.has_key? f and params[f].blank?
        form_complete = false
      end
    end
    if form_complete
      @snapshot_id=snapshot.create_snapshot(@vol, params[:name], params[:description])
      redirect_to snapshot_info_path(:snap_id =>  @snapshot_id)
    else  
      render 'snapshots/new_snapshot'
      flash.alert = "Complete all the fields."
    end

  end

  def delete_snapshot 
    snapshot = ForemanPluginTemplate::DiskManagement.new
    @snap = params[:snap_id]
    @snapshots = snapshot.delete_snapshot(@snap)
    puts @snap
    puts "works delete"
  end

end