class Admin::LevelsController < Admin::BaseController

  def index
    @levels = Level.all
    respond_to do |format|
      format.html
    end
  end

  def destroy
    Level.find(params[:id]).delete
    redirect_to(admin_levels_path)
  end
end
