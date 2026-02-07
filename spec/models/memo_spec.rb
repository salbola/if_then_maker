require "rails_helper"

RSpec.describe Memo, type: :model do
  let(:user) { User.create }
  describe "バリデーション" do
    it "title があれば有効" do
      memo = build(:memo, title: "テストメモ", user: user)
      expect(memo).to be_valid
    end

    it "title が空だと無効" do
      memo = build(:memo, title: nil, user: user)
      expect(memo).not_to be_valid
      expect(memo.errors[:title]).to include("can't be blank")
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
end
