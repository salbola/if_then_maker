class ReflectionPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def create?
    user.present?
  end

  def destroy?
    owner?
  end

  class Scope < ApplicationPolicy::Scope

    def resolve
      scope.where(user: user)
    end
  end

  private

  def owner?
    user.present? && record.user_id == user.id
  end
end
