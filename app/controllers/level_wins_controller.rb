class LevelWinsController < ApplicationController
  def create
    @level = LevelWin.new(params[:level_win]);

    if (signed_in?)
      @level.user = current_user
    end

    if @level.save
      render :text => 'OK'
    end
  end

  def index
    @level = Level.includes(:level_wins => :user).find(params[:level_id])
  end

  def show
    @level_win = LevelWin.find(params[:id])
    @level = @level_win.level
  end
end
