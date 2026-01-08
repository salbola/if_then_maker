require "rails_helper"

RSpec.describe IfThenRuleForm, type: :model do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  describe "#valid?の本来のバリデーションの役目" do
    it "if_condition と then_action があれば valid" do
      form = IfThenRuleForm.new(
        { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1, },
        user: user
      )
      expect(form).to be_valid
    end

    it "if_condition が空だと invalid" do
      form = IfThenRuleForm.new(
        { if_condition: "", then_action: "水を飲む", memo_id: 1, },
        user: user
      )
      expect(form).not_to be_valid
    end

    it "then_action が空だと invalid" do
      form = IfThenRuleForm.new(
        { if_condition: "朝起きたら", then_action: "", memo_id: 1, },
        user: user
      )
      expect(form).not_to be_valid
    end
  end
  describe "#valid?で追加されるwarningsの機能" do
    context "適切な値の時" do
      it "if_condition と then_action が適正ならwarningsが空になる" do
        form = IfThenRuleForm.new(
          { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1, },
          user: user
        )
        form.valid?
        expect(form.warnings).to eq([])
      end
    end
    context "ifがおかしい場合" do
      it "if_condition によくない文字'常に'があるとwarningsに追加される" do
        form = IfThenRuleForm.new(
          { if_condition: "常に", then_action: "水を飲む", memo_id: 1, },
          user: user
        )
        form.valid?
        expect(form.warnings).to be_present
      end
      it "if_condition に同じユーザーですでに同じものがあるとwarningsに追加される" do
        create(:if_then_rule, user: user, memo: memo, if_condition: "常に", then_action: "水を飲む")
        form = IfThenRuleForm.new(
          { if_condition: "常に", then_action: "水を吐く" ,memo_id: 1,},
          user: user
        )
        form.valid?
        expect(form.warnings).to be_present
      end
    end
    context "then_がおかしい場合" do
      it "then_action に不適切な表現がある場合 warnings に追加される" do
      form = IfThenRuleForm.new(
        {
          memo_id: 1,
          if_condition: "朝起きたら",
          then_action: "なんか考える"
        },
        user: user
      )

      form.valid?
      expect(form.warnings).to be_present
      end
    end
  end
end
