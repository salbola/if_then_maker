require "rails_helper"
RSpec.describe "Rule flow", type: :system do
  it "ユーザーが登録し、ログインして、メモとルールを作成できる" do
    # 1. 新規登録
    visit new_user_path
    expect(page).to have_content("ダッシュボード")
    fill_in "user_email", with: "test@example.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "commit"

    expect(page).to have_content("登録が成功しました")

    # # 2. ログイン
    # visit login_path
    # expect(page).to have_content("ログイン")
    # fill_in "user_email", with: "test@example.com"
    # fill_in "user_password", with: "password"
    # click_button "commit"

    # expect(page).to have_content("ログインが成功しました")

    # 3. 作成フローに入る
    click_link "新しくマイルールを作成する"
    expect(page).to have_content("メモ選択")

    # 4 メモの選択or新しいメモ作成
    click_link "新しくメモを作成する"
    fill_in "memo_title", with: "朝するといいこと"
    fill_in "memo_body", with: "筋トレ"
    click_button "commit"

    expect(page).to have_content("メモの作成が成功しました")


    # 4. ルール作成
    click_link "このメモで新しいマイルールを作る"
    fill_in "if_then_rule_form_if_condition", with: "朝起きたら"
    fill_in "if_then_rule_form_then_action", with: "腕立て伏せ3回する"
    check "commit_type"
    click_button "button"

    expect(page).to have_content("作成しました")
  end
end
