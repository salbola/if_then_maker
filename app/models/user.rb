class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :email, presence: true, uniqueness: true

  validates :password,
            length: { minimum: 3 },
            confirmation: true,
            if: -> { new_record? || will_save_change_to_crypted_password? }

  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || will_save_change_to_crypted_password? }
end