RSpec.describe "Memos", type: :request do
  include LoginHelper
  let(:user) { create(:user, password: "password") }
  let(:memo) { create(:memo, user: user) }

  describe "GET /memos(メモ一覧表示)" do
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get memos_path
        expect(response).to redirect_to(login_path)
      end
    end

    context "ログインしている場合" do
      it "一覧が表示される" do
        login_as(user)
        get memos_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("メモ一覧")
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
    context "正常系" do
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

        expect(response).to redirect_to(memo_path(Memo.first))
      end
    end
      context "異常系" do
        context "ログインしている場合" do
          it "作成に失敗しnewを再表示する" do
            login_as(user)

            post memos_path, params: {
              memo: {
                title: "",
                body: "本文"
              }
            }

            expect(response).to have_http_status(:unprocessable_content)
            expect(response.body).to include("メモの作成")
          end
        end
      end
  end
  describe "PATCH /memos/:id(edit->updateのテスト)" do
    it "メモを更新できる" do
      login_as(user)

      patch memo_path(memo), params: {
        memo: { title: "更新後タイトル" }
      }

      expect(response).to redirect_to(memo_path(memo))
      expect(memo.reload.title).to eq("更新後タイトル")
    end
  end
  describe "DELETE /memos/:id(destroyのテスト)" do
    it "メモを削除できる" do
      login_as(user)
      memo

      expect {
        delete memo_path(memo)
      }.to change(Memo, :count).by(-1)

      expect(response).to redirect_to(memos_path)
    end
  end
end
