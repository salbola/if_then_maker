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
    record == user
  end

  def update?
    record == user
  end

  # def destroy?
  #   record == user
  # end

  class Scope < ApplicationPolicy::Scope

    def resolve
      scope.find( user.id )
    end
  end
end
