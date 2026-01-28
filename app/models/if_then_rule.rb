class IfThenRule < ApplicationRecord
  belongs_to :user
  belongs_to :memo
  has_many :reflections, dependent: :destroy

  enum status: { draft: 0, active: 1, habituated: 2 }
  validates :if_condition, presence: true, if: :active?
  validates :then_action, presence: true, if: :active?
  validates :status, presence: true

  def reflected_today?
  reflections.exists?(reflected_on: Date.current)
  end

  def today_reflection
    reflections.find_by(reflected_on: Date.current)
  end

  def human_status
    case status
    when "draft" then "未実行"
    when "active" then "実行中"
    when "habituated" then "定着済み"
    end
  end
end
