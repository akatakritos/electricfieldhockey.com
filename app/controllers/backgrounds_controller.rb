require 'securerandom'
class BackgroundsController < ApplicationController
  def create

    uploaded_io = params[:image]
    filename = SecureRandom.hex + File.extname(uploaded_io.original_filename)
    filepath = Rails.root.join('public','uploads', 'maps', filename)
    fileurl = '/public/uploads/maps/' + filename
    File.open(filepath, 'w') do |file|
      file.write( uploaded_io.read )
    end
    render :json => { :url => fileurl }, :status => :created, :location => fileurl
  end
end
