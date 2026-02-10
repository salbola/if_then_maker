class Memo < ApplicationRecord
  belongs_to :user
  has_many :if_then_rules, dependent: :nullify
  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 10_000 }


  def display_title
    title.present? ? title.truncate(20) : "（無題）"
  end

  def display_for_select
    title_text = title.present? ? title.truncate(20) : "（無題）"
    body_text = body.presence&.truncate(10)
    "#{title_text} - #{body_text}"
  end

end
