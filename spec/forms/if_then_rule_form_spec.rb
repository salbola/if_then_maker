require "rails_helper"

RSpec.describe IfThenRuleForm, type: :model do
  let(:user) { create(:user) }
  let(:memo) { create(:memo, user: user) }
  let(:if_then_rule) do
  create(
    :if_then_rule,
    user: user,
    memo: memo,
    if_condition: "朝起きたら",
    then_action: "水を飲む",
    status: "draft"
  )
end
  describe "#valid?について" do
  describe "正しい場合のバリデーション" do
    context "if_condition と then_action があれば" do
      it "valid" do
        form = IfThenRuleForm.new(
          { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1, weekdays: [] },
          user: user
          )
          expect(form).to be_valid
        end
      end
    end
    describe "if_conditionのバリデーション" do
      context "if_condition が空だと " do
        it "invalid" do
          form = IfThenRuleForm.new(
            { if_condition: "", then_action: "水を飲む", memo_id: 1 },
            user: user
            )
            expect(form).not_to be_valid
        end
      end
    end

    describe "then_actionのバリデーション" do
      context "then_action が空だと " do
        it "invalid" do
          form = IfThenRuleForm.new(
            { if_condition: "朝起きたら", then_action: "", memo_id: 1 },
            user: user
          )
          expect(form).not_to be_valid
        end
      end
    end

    describe "weekdaysのバリデーション" do
      context "0〜6のみの場合は" do
        it "valid" do
          form = described_class.new(
            { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1 ,weekdays: %w[0 3 6] },
            user: user
          )

          expect(form).to be_valid
        end
      end
      context "0〜6以外の場合は" do
        it "invalid" do
            form = described_class.new(
              { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1 ,weekdays: %w[0 7] },
              user: user
            )

            expect(form).not_to be_valid
            expect(form.errors[:weekdays]).to include("に不正な値が含まれています")
        end
      end
      context  "空配列の場合" do
        it "有効（毎日扱い）" do
          form = described_class.new(
            { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1 ,weekdays: [] },
            user: user
          )
          expect(form).to be_valid
        end
      end
    end


  end
  describe "#valid?で追加されるwarningsの機能" do
    context "適切な値の時" do
      it "if_condition と then_action が適正ならwarningsが空になる" do
        form = IfThenRuleForm.new(
          { if_condition: "朝起きたら", then_action: "水を飲む", memo_id: 1 },
          user: user
        )
        form.valid?
        expect(form.warnings).to eq([])
      end
    end
    context "ifがおかしい場合" do
      it "if_condition によくない文字'常に'があるとwarningsに追加される" do
        form = IfThenRuleForm.new(
          { if_condition: "常に", then_action: "水を飲む", memo_id: 1 },
          user: user
        )
        form.valid?
        expect(form.warnings).to be_present
      end
      it "if_condition に同じユーザーですでに同じif_conditionのものがあるとwarningsに追加される" do
        if_then_rule
        form = IfThenRuleForm.new(
          { if_condition: "常に", then_action: "水を吐く", memo_id: 1  },
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


  describe "#save（新規作成）" do
    context "errorやwarning がない場合" do
      it ".saveでupdateではなく新規作成(create)される" do
        form = IfThenRuleForm.new(
          {
            memo_id: memo.id,
            if_condition: "朝起きたら",
            then_action: "水を飲む",
            status: :active
          },
          user: user
        )
        expect {
          form.save
        }.to change { user.if_then_rules.count }.by(1)
      end
    end

    context "validation error がある場合" do
      it "保存されない" do
        form = IfThenRuleForm.new(
          {
            memo_id: memo.id,
            if_condition: "",
            then_action: "水を飲む",
            status: :active
          },
          user: user
        )

        expect(form.save).to be false
      end
    end

    context "warning になる値の場合" do
      it "ignore_warnings: false では保存されない" do
        form = IfThenRuleForm.new(
          {
            memo_id: memo.id,
            if_condition: "常に",
            then_action: "水を飲む",
            status: :active
          },
          user: user
        )

        expect(form.save).to be false
      end

      it "ignore_warnings: true では保存される" do
        form = IfThenRuleForm.new(
          {
            memo_id: memo.id,
            if_condition: "常に",
            then_action: "水を飲む",
            status: :active
          },
          user: user
        )

        expect {
          form.save(ignore_warnings: true)
        }.to change { user.if_then_rules.count }.by(1)
      end
    end
  end
  describe "#save（編集時）" do
    context "正常系" do
      context "error・warning がない場合" do
        it "create されず update が行われる" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: "夜寝る前に",
              then_action: "ストレッチ",
              status: "draft"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          expect {
            form.save(ignore_warnings: false)
          }.not_to change { IfThenRule.count }
          puts if_then_rule
          expect(if_then_rule.reload.if_condition).to eq("夜寝る前に")
        end

        it "if_condition / then_action / status が更新される" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: "夜寝る前に",
              then_action: "ストレッチ",
              status: "active"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          form.save(ignore_warnings: false)

          if_then_rule.reload
          expect(if_then_rule.if_condition).to eq("夜寝る前に")
          expect(if_then_rule.then_action).to eq("ストレッチ")
          expect(if_then_rule.status).to eq("active")
        end
      end
    end
    context "異常系" do
      context "validation error がある場合" do
        it "save に失敗する" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: "",
              then_action: "水を飲む",
              status: "active"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          expect(form.save).to be false
          expect(if_then_rule.reload.if_condition).to eq("朝起きたら")
        end
      end

      context "warning がある場合" do
        it "ignore_warnings: false では save に失敗する" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: "常に",
              then_action: "水を飲む",
              status: "draft"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          expect(form.save).to be false
        end
      end
    end


    context "編集特有の warning 制御" do
      context "if_condition を変更していない場合" do
        it "自分自身との重複 warning が出ない" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: "朝起きたら", # 変更なし
              then_action: "水を飲む",
              status: "draft"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          form.valid?
          expect(form.warnings).to be_empty
        end
      end

      context "status を draft → active に変更する場合" do
        context "すでに active が 3 件以上あるとき" do
          before do
            create_list(
              :if_then_rule,
              3,
              user: user,
              memo: memo,
              status: "active"
            )
          end

          it "warning が出る" do
            form = IfThenRuleForm.new(
              {
                memo_id: memo.id,
                if_condition: "朝起きたら",
                then_action: "水を飲む",
                status: "active"
              },
              user: user,
              if_then_rule_of_model: if_then_rule
            )

            form.valid?
            expect(form.warnings).to be_present
          end
        end
      end
      context "status がもともと active の場合" do
        let(:if_then_rule) do
          create(
            :if_then_rule,
            user: user,
            memo: memo,
            status: "active"
          )
        end

        before do
          create_list(
            :if_then_rule,
            3,
            user: user,
            memo: memo,
            status: "active"
          )
        end

        it "active が 3 件以上あっても warning が出ない" do
          form = IfThenRuleForm.new(
            {
              memo_id: memo.id,
              if_condition: if_then_rule.if_condition,
              then_action: if_then_rule.then_action,
              status: "active"
            },
            user: user,
            if_then_rule_of_model: if_then_rule
          )

          form.valid?
          expect(form.warnings).to be_empty
        end
      end
    end
  end

  describe "weekdaysの正規化" do
    context "7個選択した場合" do
      it "空配列に正規化される" do
        form = described_class.new(
          { weekdays: %w[0 1 2 3 4 5 6] },
          user: user
        )

        expect(form.weekdays).to eq([])
      end
    end
    context "文字列として渡された(paramsの特性)場合" do
      it "整数配列になる" do
        form = described_class.new(
          {
          if_condition: "常に",
          then_action: "水を飲む",
          memo_id: memo.id,
          weekdays: %w[1 3] },
          user: user
        )

        expect(form.weekdays).to eq([1, 3])
      end
    end
  end

end
