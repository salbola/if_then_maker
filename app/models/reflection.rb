class Reflection < ApplicationRecord
  belongs_to :user
  belongs_to :if_then_rule

  validates :reflected_on, presence: true
  scope :today, -> { where(reflected_on: Date.current) }
end
