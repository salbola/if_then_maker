# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザーバリデーション関連' do
    context '正常系' do
      it 'email と password が正しければ有効' do
        user = build(:user)

        expect(user).to be_valid
      end
    end

    context '異常系: email' do
      it 'email が空だと無効' do
        user = build(:user, email: nil)

        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end

      it 'email がユニークでないと無効' do
        create(:user, email: 'test@example.com')

        duplicate_user = build(
          :user,
          email: 'test@example.com'
        )

        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include('has already been taken')
      end
    end

    context '異常系: password' do
      it 'password が短すぎると無効(現状3文字!)' do
        user = build(
          :user,
          password: 'ab',
          password_confirmation: 'ab'
        )

        expect(user).not_to be_valid
        expect(user.errors[:password]).to include(
          'is too short (minimum is 3 characters)'
        )
      end

      it 'password_confirmation がないと無効' do
        user = build(
          :user,
          password_confirmation: nil
        )

        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("can't be blank")
      end

      it 'password と password_confirmation が一致しないと無効' do
        user = build(
          :user,
          password_confirmation: 'different_passworddddd!'
        )

        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include(
          "doesn't match Password"
        )
      end
    end
  end
  describe 'password,password_confirmationの暗号化や保存' do
    it 'password,password_confirmationとしての保存時にcrypted_password,saltが生成されている' do
    user = create(:user)

    expect(user.crypted_password).to be_present
    expect(user.salt).to be_present
    end
  end

  describe "#all_rules_completed_today?" do
    let(:user) { create(:user) }
    let(:memo) { create(:memo, user: user) }
    context "すべてのactiveルールが今日完了しているとき" do
      it "trueを返す" do
        rule1 = create(:if_then_rule, user: user, memo: memo, status: :active)
        rule2 = create(:if_then_rule, user: user, memo: memo, status: :active)

        create(:reflection, user: user,  if_then_rule: rule1, reflected_on: Date.current)
        create(:reflection, user: user,  if_then_rule: rule2, reflected_on: Date.current)

        expect(user.all_rules_completed_today?).to eq true
      end
    end

    context "activeルールの一部が未完了のとき" do
      it "falseを返す" do
        rule1 = create(:if_then_rule, user: user, memo: memo, status: :active)
        rule2 = create(:if_then_rule, user: user, memo: memo, status: :active)

        create(:reflection, user: user,  if_then_rule: rule1, reflected_on: Date.current)

        expect(user.all_rules_completed_today?).to eq false
      end
    end

    context "activeルールが存在しないとき" do
      it "trueを返す" do
        expect(user.all_rules_completed_today?).to eq true
      end
    end
  end
end
