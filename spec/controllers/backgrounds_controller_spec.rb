require 'spec_helper'

describe BackgroundsController do
  describe '#create' do
    before :each do
      @file = fixture_file_upload("/files/upload.jpg", "image/jpg")
    end

   it 'can upload a file' do
    post :create, :image => @file
    response.should be_success
   end
  
   it 'should have a location header' do
     post :create, :image => @file
     response.header['Location'].should_not be_nil
   end

   it 'should have a file at the location' do
     post :create, :image => @file
     path = Rails.root.join('public', *response.header['Location'].split('/'))
     File.exists?(path).should be_true
   end

   it 'should have a file in the json response' do
     post :create, :image => @file
     json = JSON.parse(response.body)
     json["url"].should_not be_nil
     path = Rails.root.join('public', *json['url'].split('/'))
     File.exists?(path).should be_true
   end
  end
end

