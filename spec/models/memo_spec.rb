require "rails_helper"

RSpec.describe Memo, type: :model do
  let(:user) { create(:user) }
  describe "バリデーション" do
    it "title があれば有効" do
      memo = build(:memo, title: "テストメモ", user: user)
      expect(memo).to be_valid
    end


    it "title が100文字を超えると無効" do
      memo = build(:memo, title: "a" * 101, user: user)
      expect(memo).not_to be_valid
    end
  end
  describe "#display_for_select" do
    it "titleとbodyを結合して表示する" do
      memo = build(:memo, title: "タイトル", body: "本文")

      expect(memo.display_for_select).to eq("タイトル - 本文")
    end

    it "titleがない場合は無題になる" do
      memo = build(:memo, title: nil, body: "本文")

      expect(memo.display_for_select).to start_with("（無題）")
    end

    it "bodyがnilでもエラーにならずハイフンだけ残る" do
      memo = build(:memo, title: "タイトル", body: nil)

      expect(memo.display_for_select).to end_with(" - ")
    end
  end

  describe ".stale" do
    context "取得される条件" do
      it "7日以上前かつルールがない場合に取得されること" do
        memo = create(:memo,
          user: user,
          updated_at: 8.days.ago)

        expect(Memo.stale).to include(memo)
      end
    end
    context "取得されない条件" do
      it "updated_atが6日前の場合取得されないこと" do
        memo = create(:memo,
        user: user,
        updated_at: 6.days.ago
      )

      expect(Memo.stale).not_to include(memo)
      end

      it 'ルールが存在する場合取得されないこと' do
        memo = create(:memo,
          user: user,
          updated_at: 10.days.ago
        )

        create(:if_then_rule, memo: memo, user: user)

        expect(Memo.stale).not_to include(memo)
      end
    end
  end
end
