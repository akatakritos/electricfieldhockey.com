class ErrorsController < ApplicationController

  def not_found
    render :status => 404, :formats => [:html]
  end

  def internal_error
    render :status => 500, :formats => [:html]
  end


end
