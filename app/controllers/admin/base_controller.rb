module Admin
  class BaseController < ApplicationController
    before_filter :satisifies_admin_policy

    private
      def satisifies_admin_policy
        if !signed_in?
          flash[:info] = 'Please Log In'
          redirect_to signin_path
        elsif !::AdminPolicy.new(current_user).permitted?
          flash[:error] = 'Access Denied'
          redirect_to root_path
        end
      end
  end
end
