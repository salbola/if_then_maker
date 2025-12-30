require "rails_helper"

RSpec.describe IfThenRule, type: :model do
  let(:user) { create(:user)}
  let(:memo) { create(:memo, user: user) }
  describe "statusがactiveかdraft含めてバリデーションの確認" do
    context "statusがdraftの時" do
      it 'ifやthenの値がnilでもdraft状態ならバリデーションが機能しないでvalidになる' do
        if_then_rule = build(:if_then_rule, if_condition: nil, then_action: nil, user: user, memo: memo, status: :draft)

        expect(if_then_rule).to be_valid
        expect(if_then_rule.errors).to be_empty
      end
    end
    context "statusがactiveの時" do
      it 'if_conditionの値がnilだとバリデーションが機能してinvalidになる' do
        if_then_rule = build(:if_then_rule, if_condition: nil, user: user, memo: memo, status: :active)

        expect(if_then_rule).not_to be_valid
        expect(if_then_rule.errors[:if_condition]).to include("can't be blank")
      end
      it 'then_actionの値がnilだとバリデーションが機能してinvalidになる' do
        if_then_rule = build(:if_then_rule, then_action: nil, user: user, memo: memo, status: :active)

        expect(if_then_rule).not_to be_valid
        expect(if_then_rule.errors[:then_action]).to include("can't be blank")
      end
      it 'then_actionの値があればバリデーションが機能してvalidになる' do
        if_then_rule = build(:if_then_rule, user: user, memo: memo, status: :active)

        expect(if_then_rule).to be_valid
        expect(if_then_rule.errors).to be_empty
      end
    end
  end

  describe "バリデーションstatus" do
    it "statusがnilの場合invalidになる" do
      if_then_rule = build(:if_then_rule, user: user, memo: memo, status: nil)

      expect(if_then_rule).not_to be_valid
      expect(if_then_rule.errors[:status]).to include("can't be blank")
    end
  end
end