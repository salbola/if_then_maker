class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :memos, dependent: :destroy
  has_many :if_then_rules, dependent: :destroy
  has_many :reflections, dependent: :destroy
  validates :email, presence: true, uniqueness: true

  validates :password,
            length: { minimum: 3 },
            confirmation: true,
            if: -> { new_record? || will_save_change_to_crypted_password? }

  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || will_save_change_to_crypted_password? }

  def  all_rules_completed_today?
    today_rules = if_then_rules.active
    completed = today_rules.all?(&:reflected_today?)
  end
end
