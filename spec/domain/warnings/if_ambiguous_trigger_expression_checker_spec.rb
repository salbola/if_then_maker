require "rails_helper"
RSpec.describe Warnings::IfAmbiguousTriggerExpressionChecker do
   describe ".check" do
    context "問題のある表現を含む場合" do
      it "『常に』を含むと warning を返す" do
        warnings = described_class.check("常に水を飲む")

        expect(warnings).to eq([
  {
    field: :if_condition,
    concept: :if_ambiguous_trigger_expression,
    pattern: :always_expression,
    matches: [ "常に" ]
  }
])
      end
    end

    context "問題のない表現の場合" do
      it "warning を返さない" do
        warnings = described_class.check("7時に起きたら水を飲む")

        expect(warnings).to be_empty
      end
    end

    context "空文字や nil の場合" do
      it "空文字では warning を返さない" do
        warnings = described_class.check("")

        expect(warnings).to be_empty
      end

      it "nil では warning を返さない" do
        warnings = described_class.check(nil)

        expect(warnings).to be_empty
      end
    end
  end
end
