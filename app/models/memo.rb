class Memo < ApplicationRecord
  belongs_to :user
  has_many :if_then_rules, dependent: :nullify
  validates :title, length: { maximum: 100 }
  validates :body, length: { maximum: 10_000 }
# 未整理のメモは7日以上前かつルールとの紐付けがないものとして今回は指定している,調整にはdaysで変える。
  scope :stale, ->(days = 7) {
  left_outer_joins(:if_then_rules)
    .where(if_then_rules: { id: nil })
    .where("memos.updated_at <= ?", days.days.ago)
}

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "body" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "if_then_rules" ]
  end

  def display_title
    title.present? ? title.truncate(20) : "（無題）"
  end

  def display_for_select
    title_text = title.present? ? title.truncate(20) : "（無題）"
    body_text = body.presence&.truncate(10)
    "#{title_text} - #{body_text}"
  end
end
