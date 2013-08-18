include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "session_username", :with => user.username.upcase
  fill_in "session_password", :with => user.password
  click_button 'Sign In'
  cookies[:remember_token] = user.remember_token
end