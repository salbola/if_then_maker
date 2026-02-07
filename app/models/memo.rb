class Memo < ApplicationRecord
  belongs_to :user
  has_many :if_then_rules, dependent: :nullify
  validates :title, presence: :true, length: { maximum: 100 }
  validates :body, length: { maximum: 10_000 }

  def display_for_select
    title_text = title.present? ? title.truncate(10) : "（無題）"
    body_text = body.present? ? body.truncate(10) : "(本文はありません)"
    "#{title_text}：#{body_text}"
  end
end
