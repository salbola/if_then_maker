class IfThenRulePolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def show?
    owner?
  end

  def edit?
    owner?
  end

  def update?
    owner?
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
