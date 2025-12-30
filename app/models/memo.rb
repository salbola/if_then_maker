class Memo < ApplicationRecord
  belongs_to :user
  has_many :if_then_rules, dependent: :destroy
  validates :title, presence: :true, length: { maximum: 100 }
  validates :body, length: { maximum: 10_000 }
end
