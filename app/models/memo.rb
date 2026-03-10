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
  # 値がない場合に対応したタイトル表示のメソッド
  def display_title
    title.present? ? title.truncate(20) : "（無題）"
  end

  # 値がない場合に対応したメモの本文を表示するメソッド limitがnilなら全文
  def display_body(limit: 30)
    return "（本文がありません）" if body.blank?
    return body if limit.nil?

    body.truncate(limit)
  end
  # セレクトのフォームフィールドで使用
  def display_for_select
    title_text = title.present? ? title.truncate(20) : "（無題）"
    body_text = body.presence&.truncate(10)
    "#{title_text} - #{body_text}"
  end
end
