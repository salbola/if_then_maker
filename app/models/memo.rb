class Memo < ApplicationRecord
  belongs_to :user
  validates :title, presence: :true, length: { maximum: 100 }
  validates :body, length: { maximum: 10_000 }
end
