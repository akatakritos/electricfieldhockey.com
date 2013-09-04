require 'securerandom'
class BackgroundsController < ApplicationController
  def create

    upload = UploadedBackground.new(params[:image]).save
    render :json => { :url => upload.file_uri}, :status => :created, :location => upload.file_uri
  end
end
