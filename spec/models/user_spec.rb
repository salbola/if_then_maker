require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context '正常系' do
      it 'email と password が正しければ作成できる' do
        user = User.new(
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        )

        expect(user).to be_valid
      end
    end

    context '異常系: email' do
      it 'email が空だと無効' do
        user = User.new(
          email: nil,
          password: 'password',
          password_confirmation: 'password'
        )

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'email がユニークでないと無効' do
        User.create!(
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        )

        duplicate_user = User.new(
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        )

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include('has already been taken')
      end
    end

    context '異常系: password' do
      it 'password が短すぎると無効' do
        user = User.new(
          email: 'test2@example.com',
          password: 'ab',
          password_confirmation: 'ab'
        )

        expect(user).not_to be_valid
        expect(user.errors[:password]).to include('is too short (minimum is 3 characters)')
      end

      it 'password_confirmation がないと無効' do
        user = User.new(
          email: 'test3@example.com',
          password: 'password',
          password_confirmation: nil
        )

        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("can't be blank")
      end

      it 'password と password_confirmation が一致しないと無効' do
        user = User.new(
          email: 'test4@example.com',
          password: 'password',
          password_confirmation: 'different'
        )

        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
    end
  end
end