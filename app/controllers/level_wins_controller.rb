class LevelWinsController < ApplicationController
  def create
    @level = LevelWin.new(params[:level_win]);
    if @level.save
      render :text => 'OK'
    end
  end
end
