class Reflection < ApplicationRecord
  belongs_to :user
  belongs_to :if_then_rule

  validates :reflected_on, presence: true
end
