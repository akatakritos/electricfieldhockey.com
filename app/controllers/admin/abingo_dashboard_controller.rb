#Create a new controller.  The name is up to you -- this example
#uses abingo_dashboard_controller.rb
class Admin::AbingoDashboardController < Admin::BaseController
#Declare any before_filters or similar which you need to use your authentication
#for this controller.
 
include Abingo::Controller::Dashboard
end
