class IfThenRule < ApplicationRecord
  belongs_to :user
  belongs_to :memo

  enum status: { draft: 0, active: 1, done: 2 }
  validates :if_condition, presence: true, if: :active?
  validates :then_action, presence: true, if: :active?
  validates :status, presence: true
end
