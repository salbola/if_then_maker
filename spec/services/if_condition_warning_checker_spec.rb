RSpec.describe IfConditionWarningChecker do
   describe ".check" do
    context "問題のある表現を含む場合" do
      it "『常に』を含むと warning を返す" do
        warnings = described_class.check("常に水を飲む")

        expect(warnings).not_to be_empty
      end

      it "『あとで』を含むと warning を返す" do
        warnings = described_class.check("あとで運動する")

        expect(warnings).not_to be_empty
      end
    end

    context "問題のない表現の場合" do
      it "warning を返さない" do
        warnings = described_class.check("朝7時に起きたら水を飲む")

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
