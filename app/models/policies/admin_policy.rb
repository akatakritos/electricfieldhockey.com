class AdminPolicy
  def initialize(user)
    @user = user
  end

  def permitted?
    @user && @user.admin?
  end
end
