class LevelSetsController < ApplicationController
  # GET /level_sets
  # GET /level_sets.xml
  def index
    @level_sets = LevelSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @level_sets }
    end
  end

  # GET /level_sets/1
  # GET /level_sets/1.xml
  def show
    @level_set = LevelSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @level_set }
    end
  end

  # GET /level_sets/new
  # GET /level_sets/new.xml
  def new
    @level_set = LevelSet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @level_set }
    end
  end

  # GET /level_sets/1/edit
  def edit
    @level_set = LevelSet.find(params[:id])
  end

  # POST /level_sets
  # POST /level_sets.xml
  def create
    @level_set = LevelSet.new(params[:level_set])

    respond_to do |format|
      if @level_set.save
        format.html { redirect_to(@level_set, :notice => 'Level set was successfully created.') }
        format.xml  { render :xml => @level_set, :status => :created, :location => @level_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @level_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /level_sets/1
  # PUT /level_sets/1.xml
  def update
    @level_set = LevelSet.find(params[:id])

    respond_to do |format|
      if @level_set.update_attributes(params[:level_set])
        format.html { redirect_to(@level_set, :notice => 'Level set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @level_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /level_sets/1
  # DELETE /level_sets/1.xml
  def destroy
    @level_set = LevelSet.find(params[:id])
    @level_set.destroy

    respond_to do |format|
      format.html { redirect_to(level_sets_url) }
      format.xml  { head :ok }
    end
  end
end
