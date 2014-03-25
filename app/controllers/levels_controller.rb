require 'digest/md5'
class LevelsController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  # GET /levels
  # GET /levels.json
  def index
    @levels = Level.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render :json => @levels }
    end
  end

  # GET /levels/1
  # GET /levels/1.json
  def show
    @level = Level.find(params[:id])
    Level.increment_counter :view_count, @level.id

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render :json => @level }
    end
  end

  # GET /levels/new
  # GET /levels/new.json
  def new
    @level = Level.new
    @level.set_defaults

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @level }
    end
  end

  # POST /levels
  # POST /levels.json
  def create
    @level = Level.new(params[:level])

    filename = Digest::MD5.hexdigest(params[:level][:json]['backgroundUrl'])+".png"

    File.open(File.join('public','uploads','maps', filename), 'wb') do |f|
      f.write(Base64.decode64(params[:level][:json]['backgroundUrl'].sub('data:image/png;base64,','')))
    end
    @level.json["backgroundUrl"] = "/uploads/maps/#{filename}"


    @level.creator = current_user

    respond_to do |format|
      if @level.save
        format.html { redirect_to(@level, :notice => 'Level was successfully created.') }
        format.json  { render :json => @level, :status => :created, :location => @level }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @level.errors, :status => :unprocessable_entity }
      end
    end
  end

end
