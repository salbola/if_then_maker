require "rails_helper"

RSpec.describe IfThenRule, type: :model do
  let(:user) { create(:user) }
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
        expect(if_then_rule.errors[:if_condition]).to include("を入力してください")
      end
      it 'then_actionの値がnilだとバリデーションが機能してinvalidになる' do
        if_then_rule = build(:if_then_rule, then_action: nil, user: user, memo: memo, status: :active)

        expect(if_then_rule).not_to be_valid
        expect(if_then_rule.errors[:then_action]).to include("を入力してください")
      end
      it 'then_actionの値があればバリデーションが機能してvalidになる' do
        if_then_rule = build(:if_then_rule, user: user, memo: memo, status: :active)

        expect(if_then_rule).to be_valid
        expect(if_then_rule.errors).to be_empty
      end
    end
  end

  describe "バリデーションstatus" do
    let(:rule) { create(:if_then_rule, user: user, memo: memo) }
    it "statusがnilの場合invalidになる" do
      if_then_rule = build(:if_then_rule, user: user, memo: memo, status: nil)

      expect(if_then_rule).not_to be_valid
      expect(if_then_rule.errors[:status]).to include("を入力してください")
    end
  end
  describe "メソッド関連" do
    let(:rule) { create(:if_then_rule, user: user, memo: memo) }


    describe "#reflected_today?" do
      context "今日のreflectionがある場合" do
        before do
          create(:reflection,
            user: user,
            if_then_rule: rule,
            reflected_on: Date.current
          )
        end

        it "trueを返す" do
          expect(rule.reflected_today?).to be true
        end
      end

      context "今日のreflectionがない場合" do
        it "falseを返す" do
          expect(rule.reflected_today?).to be false
        end
      end
    end


    describe "#today_reflection" do
      context "今日のreflectionがある場合" do
        before do
          create(:reflection,
            user: user,
            if_then_rule: rule,
            reflected_on: Date.current
          )
        end

        it "オブジェクトを返す" do
          expect(rule.today_reflection).to be_present
        end
      end

      context "今日のreflectionがない場合" do
        it "nilを返す" do
          expect(rule.today_reflection).to be nil
        end
      end
    end

    describe "#scheduled_for?" do
      context "weekdays が空の場合" do
        it "どの曜日でもtrue" do
          rule = create(:if_then_rule, user: user, memo: memo, weekdays: [])

          expect(rule.scheduled_for?(Date.new(2026, 3, 2))).to be true
          expect(rule.scheduled_for?(Date.new(2026, 3, 3))).to be true
        end
      end
      context "weekdaysを設定されている場合" do
        context "設定と一致する日なら" do
          it "trueを返す" do
            rule = create(:if_then_rule, user: user, memo: memo, weekdays: [ 1 ]) # 月曜

            monday = Date.new(2026, 3, 2) # 月曜
            expect(rule.scheduled_for?(monday)).to be true
          end
        end
        context "設定と一致しない日なら" do
          it "falseを返す" do
            rule = create(:if_then_rule, user: user, memo: memo, weekdays: [ 1 ]) # 月曜

            tuesday = Date.new(2026, 3, 3)
            expect(rule.scheduled_for?(tuesday)).to be false
          end
        end
      end
    end
  end
end
