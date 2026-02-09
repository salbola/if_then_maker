require "rails_helper"

RSpec.describe TrialRuleForm do
  describe "#savable?" do
    context "正常系" do
      context "必須項目がwarnings警告不要な内容で揃っている場合" do
        it "trueを返す" do
          form = described_class.new(
            if_condition: "朝起きたら",
            then_action: "水を飲む"
          )

          expect(form.savable?).to be true
        end
      end


      context "警告(warnings)があり ignore_warnings=false の場合" do
        it "falseを返す" do
          form = described_class.new(
            if_condition: "いつも",
            then_action: "水を飲む"
          )

          expect(form.savable?).to be false
        end
      end
      context "警告(warnings)はあるが ignore_warnings=true の場合" do
        it "trueを返す" do
            form = described_class.new(
            if_condition: "いつも",
          then_action: "水を飲む"
          )
          expect(form.savable?(ignore_warnings: true)).to be true
        end
      end
    end

    context "異常系" do
      context "必須項目が欠けている場合(エラーがある場合)" do
        it "if_condition が空だと false を返す" do
          form = described_class.new(
            if_condition: "",
            then_action: "水を飲む"
          )

          expect(form.savable?).to be false
        end

        it "then_action が空だと false を返す" do
          form = described_class.new(
            if_condition: "朝起きたら",
            then_action: ""
          )

          expect(form.savable?).to be false
        end
        it "ignore_warnings=true でも false を返す" do
          form = described_class.new(
            if_condition: "",
            then_action: ""
          )

          expect(form.savable?(ignore_warnings: true)).to be false
        end
      end
    end
  end
end
