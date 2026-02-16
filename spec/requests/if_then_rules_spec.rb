require "rails_helper"

RSpec.describe "IfThenRules", type: :request do
  include LoginHelper
  let(:user) { create(:user, password: "password") }
  let(:other_user) { create(:user) }
  let(:my_memo) { create(:memo, user: user, title: "my memo") }
  let(:other_user_memo) { create(:memo, user: other_user, title: "他人のメモ") }
  let!(:my_rule) do
    create(:if_then_rule, user: user, memo: my_memo, if_condition: "my rule condition", then_action: "my rule action")
  end
  let!(:other_user_rule) do
    create(:if_then_rule, user: other_user, memo: other_user_memo, if_condition: "他人のルール条件", then_action: "他人のルールアクション")
  end

  describe "GET /if_then_rules(#index If-Thenルール一覧表示)" do
    context "ログインしている場合" do
      before do
        login_as(user)
        get if_then_rules_path
      end
      it "一覧が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("If-Thenルール一覧")
      end

      it "他のユーザーのものが含まれない" do
        expect(response.body).to include("my rule condition")
        expect(response.body).not_to include("他人のルール条件")
      end
    end
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get if_then_rules_path
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /if_then_rules/:id(#showのテスト)" do
    context "ログインしている場合" do
      before { login_as(user) }
      it "If-Thenルールが表示できる" do
        get if_then_rule_path(my_rule)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("my rule condition")
      end
      it "他のユーザーのものは表示できない" do
        get if_then_rule_path(other_user_rule)
        expect(response).to have_http_status(:not_found)
      end
    end
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get if_then_rule_path(my_rule)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /if_then_rules/new(#newのテスト)" do
    context "ログインしている場合" do
      it "If-Thenルールの新規作成画面が表示される" do
        login_as(user)
        get new_if_then_rule_path(memo_id: my_memo.id)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("もし")
      end
    end
    context "未ログインの場合" do
      it "新規作成画面(#new)へのアクセスでlogin_pathにリダイレクトされる" do
        get new_if_then_rule_path(memo_id: my_memo.id)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /if_then_rules(#createのテスト)" do
    context "ログインしている場合" do
      it "If-Thenルールを作成できる" do
        login_as(user)
        expect {
          post if_then_rules_path, params: {
            if_then_rule_form: {
              memo_id: my_memo.id,
              if_condition: "朝起きたら",
              then_action: "水を飲む",
              status: "active"
            }
          }
        }.to change(IfThenRule, :count).by(1)
      end
      it "他人のメモにはルールを作成できない" do
        login_as(user)

        expect {
          post if_then_rules_path, params: {
            if_then_rule_form: {
              memo_id: other_user_memo.id,
              if_condition: "不正",
              then_action: "不正",
              status: "active"
            }
          }
        }.not_to change(IfThenRule, :count)

        expect(response).to have_http_status(:not_found)
      end
    end
    context "未ログインの場合" do
      it "新規作成処理(#create)へのアクセスでlogin_pathにリダイレクトされる" do
        post if_then_rules_path, params: {
          if_then_rule_form: {
            memo_id: my_memo.id,
            if_condition: "朝起きたら",
            then_action: "水を飲む",
            status: "active"
          }
        }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /if_then_rules/:id/edit(#editのテスト)" do
    context "ログインしている場合" do
      before { login_as(user) }
      it "編集画面を表示できる" do
        get edit_if_then_rule_path(my_rule)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("If-Thenルール編集")
      end
      it "他人のIf-Thenルールの編集画面を表示できない" do
        get edit_if_then_rule_path(other_user_rule)
        expect(response).to have_http_status(:not_found)
      end
    end
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        get edit_if_then_rule_path(my_rule)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /if_then_rules/:id(#updateのテスト)" do
    context "ログインしている場合" do
      before { login_as(user) }
      it "If-Thenルールを更新できる" do
        patch if_then_rule_path(my_rule), params: {
          if_then_rule_form: {
            memo_id: my_memo.id,
            if_condition: "更新後の条件",
            then_action: "更新後のアクション",
            status: "active"
          }
        }
        expect(response).to redirect_to(if_then_rule_path(my_rule))
        expect(my_rule.reload.if_condition).to eq("更新後の条件")
      end
      it "他人のIf-Thenルールは更新できない" do
        patch if_then_rule_path(other_user_rule), params: {
          if_then_rule_form: {
            memo_id: other_user_memo.id,
            if_condition: "更新後の条件",
            then_action: "更新後のアクション",
            status: "active"
          }
        }
        expect(response).to have_http_status(:not_found)
      end

      it "他人のmemoに紐付け変更できない" do
        patch if_then_rule_path(my_rule), params: {
          if_then_rule_form: {
            memo_id: other_user_memo.id,
            if_condition: "改ざん",
            then_action: "改ざん",
            status: "active"
          }
        }

        expect(response).to have_http_status(:not_found)
      end
    end
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        patch if_then_rule_path(my_rule), params: {
          if_then_rule_form: {
            memo_id: my_memo.id,
            if_condition: "朝起きたら",
            then_action: "水を飲む",
            status: "active"
          }
        }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /if_then_rules/:id(destroyのテスト)" do
    context "ログインしている場合" do
      before { login_as(user) }
      it "If-Thenルールを削除できる" do
        expect {
          delete if_then_rule_path(my_rule)
        }.to change(IfThenRule, :count).by(-1)
        expect(response).to redirect_to(if_then_rules_path)
      end
      it "他人のIf-Thenルールを削除できない" do
        rule_count = IfThenRule.count
        delete if_then_rule_path(other_user_rule)
        expect(IfThenRule.count).to eq(rule_count)
        expect(response).to have_http_status(:not_found)
      end
    end
    context "未ログインの場合" do
      it "login_pathにリダイレクトされる" do
        delete if_then_rule_path(my_rule)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
