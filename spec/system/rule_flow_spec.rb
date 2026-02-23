require "rails_helper"
RSpec.describe "Rule flow", type: :system do

  it "ユーザーが登録し、ログインして、メモとルールを作成できる" do
    # 1. 新規登録
    visit new_user_path
    expect(page).to have_content("新規登録")
    fill_in "user_email", with: "test@example.com"
    fill_in "user_password", with: "password"
    fill_in "user_password_confirmation", with: "password"
    click_button "commit"

    expect(page).to have_content("登録が成功しました")


  end
end