class IfThenRule < ApplicationRecord
  belongs_to :user
  belongs_to :memo, optional: true
  has_many :reflections, dependent: :destroy

  enum status: { inactive: 0, active: 1, habituated: 2, draft: 3 }
  validates :if_condition, presence: true, unless: :draft?
  validates :then_action, presence: true, unless: :draft?
  validates :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "if_condition", "memo_id", "status", "then_action", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["memo", "reflections"]
  end

  def reflected_today?
  reflections.exists?(reflected_on: Date.current)
  end

  def today_reflection
    reflections.find_by(reflected_on: Date.current)
  end

  def human_status
    case status
    when "draft" then "下書き"
    when "inactive" then "停止中"
    when "active" then "実行中"
    when "habituated" then "定着済み"
    end
  end
end
