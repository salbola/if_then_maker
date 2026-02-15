class UserPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    true
  end

  # def show?
  #   record == user
  # end

  def edit?
    own?
  end

  def update?
    own?
  end

  # def destroy?
  #   record == user
  # end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user
      scope.where(id: user.id)
    end
  end

  private

  def own?
    user.present? && record.id == user.id
  end
end
