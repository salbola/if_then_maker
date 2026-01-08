RSpec.describe ThenActionWarningChecker do
  describe ".check" do
    context "問題のある表現を含む場合" do
      it "抽象的な動詞が含まれる場合 warning を返す" do
        warnings = described_class.check("メッチャ考える")

        expect(warnings).to be_present
      end
    end
    context "問題のない表現の場合" do
      it "warning を返さない" do
        warnings = described_class.check("ノートを開く")

        expect(warnings).to be_empty
      end
    end
  end
end