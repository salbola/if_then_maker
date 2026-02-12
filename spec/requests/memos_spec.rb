RSpec.describe "Memos", type: :request do
  include LoginHelper
  let(:user) { create(:user, password: "password") }
  let(:memo) { create(:memo, user: user) }
  let(:other_user) { create(:user) }
  let!(:my_memo) do
    create(:memo, user: user, title: "my memo")
  end

  let!(:other_user_memo) do
    create(:memo, user: other_user, title: "other memo")
  end



  describe "GET /memos(メモ一覧表示)" do
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get memos_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログインしている場合" do
      before do
        login_as(user)
        get memos_path
      end
      it "一覧が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("メモ一覧")
      end

      it "他のユーザーのものが含まれない" do
        expect(response.body).to include("my memo")
        expect(response.body).not_to include("other memo")
      end
    end
  end
  describe "POST /memos(new->createのテスト)" do
    context "未ログインの場合" do
      it "新規作成画面(#new)へのアクセスでlogin_pathにリダイレクトされる" do
        get new_memo_path
        expect(response).to redirect_to(login_path)
      end
      it "新規作成処理(#create)へのアクセスでlogin_pathにリダイレクトされる" do
        post memos_path, params: {
            memo: {
              title: "テストメモ",
              body: "本文"
            }
          }

        expect(response).to redirect_to(login_path)
      end
    end
    context "ログインしている場合" do
      it "メモを作成できる" do
        login_as(user)

        expect {
          post memos_path, params: {
            memo: {
              title: "テストメモ",
              body: "本文"
            }
          }
        }.to change(Memo, :count).by(1)
      end
    end
  end
  describe "PATCH /memos/:id(edit->updateのテスト)" do
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        patch memo_path(memo)
        expect(response).to redirect_to(login_path)
      end
    end
    context "ログインしている場合" do
      it "メモを更新できる" do
        login_as(user)

        patch memo_path(memo), params: {
          memo: { title: "更新後タイトル" }
        }

        expect(response).to redirect_to(memo_path(memo))
        expect(memo.reload.title).to eq("更新後タイトル")
      end
    end
  end
  describe "DELETE /memos/:id(destroyのテスト)" do
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        delete memo_path(memo)
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログインしている場合" do
      it "メモを削除できる" do
        login_as(user)
        memo

        expect {
          delete memo_path(memo)
        }.to change(Memo, :count).by(-1)

        expect(response).to redirect_to(memos_path)
      end
      it "memo削除時にif_then_ruleのmemo_idがnullになる" do
        login_as(user)
        memo
        rule = create(:if_then_rule, user: user, memo: memo)

        memo.destroy

        expect(IfThenRule.exists?(rule.id)).to be true
        expect(rule.reload.memo_id).to be_nil
      end
    end
  end

  describe "GET /memos/stale(#staleのテスト)" do
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get stale_memos_path

        expect(response).to redirect_to(login_path)
      end
    end

    context "ログインしている場合" do
      before do
        login_as(user)
        get stale_memos_path
      end
      context "8日以上前の取得されるメモがある場合" do
        let!(:my_memo) do
          create(:memo, user: user, updated_at: 8.days.ago, title: "my memo")
        end

        let!(:other_user_memo) do
          create(:memo, user: other_user, updated_at: 8.days.ago, title: "other memo")
        end
        it "未整理のメモ一覧が表示される" do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include("未整理メモ一覧")
        end
        it "他のユーザーのものが含まれない" do
          expect(response.body).to include("my memo")
          expect(response.body).not_to include("other memo")
        end
      end
    end
  end
end
