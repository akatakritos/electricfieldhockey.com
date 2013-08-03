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
end
