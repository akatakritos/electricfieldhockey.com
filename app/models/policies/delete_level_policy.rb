class DeleteLevelPolicy
  def initialize(level, user)
    @level = level
    @user = user
  end

  def permitted?
    @level.user == @user || @user.admin?
  end
end
