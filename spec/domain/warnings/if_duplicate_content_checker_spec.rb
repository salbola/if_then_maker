require "rails_helper"
RSpec.describe Warnings::IfDuplicateContentChecker, type: :model do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:if_then_rule) { create(:if_then_rule, user: user, memo: memo, if_condition: "朝起きたら") }
  describe "値が重複のserviceの確認" do
    context "問題のある、 重複している場合" do
      it "ifが 既存のものと重複すると warning を返す" do
        if_then_rule
        warnings = described_class.check(user: user, if_condition: "朝起きたら")

        expect(warnings).not_to be_empty
      end
    end

    context "問題のない、 重複しない場合" do
      it "ifが 既存のものと重複しないと warning を返さない" do
        if_then_rule
        warnings = described_class.check(user: user, if_condition: "昼起きたら")

        expect(warnings).to be_empty
      end
    end

    context "空文字や nil の場合" do
      it "空文字では warning を返さない" do
        warnings = described_class.check(user: user,  if_condition: "")

        expect(warnings).to be_empty
      end

      it "nil では warning を返さない" do
        warnings = described_class.check(user: user,  if_condition: nil)

        expect(warnings).to be_empty
      end
    end
  end
end
