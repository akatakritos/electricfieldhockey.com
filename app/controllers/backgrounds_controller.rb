require 'securerandom'
class BackgroundsController < ApplicationController
  def create

    upload = UploadedBackground.new(params[:image]).save
    render :json => { :url => upload.uri}, :status => :created, :location => upload.uri
  end
end
