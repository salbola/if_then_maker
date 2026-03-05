require "rails_helper"
RSpec.describe "Rule Weekdays", type: :system do

  let!(:user) { create(:user) }
  let!(:memo) { create(:memo, user: user) }


  before do
    visit login_path
    expect(page).to have_content("ログイン")
    fill_in "session_email", with: user.email
    fill_in "session_password", with: "password"
    click_button "commit"

    expect(page).to have_content("ログインが成功しました")
  end


  describe "ルール作成での曜日設定をできる" do
    it "曜日を設定できる" do

      visit step1_if_then_rules_flow_path
      click_link "このメモから作る"

      fill_in "if_then_rule_form_if_condition", with: "朝起きたら"
      fill_in "if_then_rule_form_then_action", with: "腕立て伏せ3回する"
      check "commit_type"

      find("summary", text: "曜日の繰り返し設定").click
      check "月曜日"
      check "水曜日"

      click_button "保存する"
      expect(page).to have_content("作成しました")
      visit if_then_rules_path
      expect(page).to have_content("If-Thenルール一覧")
      expect(page).to have_content("月・水")

    end
  end
  describe "ルール編集での曜日再設定をできる" do
    it "曜日を編集して変更できる" do

      visit step1_if_then_rules_flow_path
      click_link "このメモから作る"

      fill_in "if_then_rule_form_if_condition", with: "朝起きたら"
      fill_in "if_then_rule_form_then_action", with: "腕立て伏せ3回する"
      check "commit_type"

      find("summary", text: "曜日の繰り返し設定").click
      check "月曜日"
      check "水曜日"

      click_button "保存する"
      expect(page).to have_content("作成しました")
      visit if_then_rules_path
      expect(page).to have_content("If-Thenルール一覧")
      expect(page).to have_content("月・水")
      
      click_link "編集"
      expect(page).to have_content("If-Thenルール編集")
      
      check "commit_type"
      
      find("summary", text: "曜日の繰り返し設定").click
      check "火曜日"
      check "日曜日"
      
      click_button "保存する"
      
      expect(page).to have_content("編集しました")

      expect(page).not_to have_content("月・水")
    end
  end
  describe "表示関連" do

    it "未入力で毎日と表示される" do

      visit step1_if_then_rules_flow_path
      click_link "このメモから作る"

      fill_in "if_then_rule_form_if_condition", with: "朝起きたら"
      fill_in "if_then_rule_form_then_action", with: "腕立て伏せ3回する"
      check "commit_type"

      find("summary", text: "曜日の繰り返し設定").click


      click_button "保存する"

      visit if_then_rules_path
      expect(page).to have_content("If-Thenルール一覧")
      expect(page).to have_content("毎日")
    end
    it "全ての曜日入力で毎日と表示される" do

      visit step1_if_then_rules_flow_path
      click_link "このメモから作る"

      fill_in "if_then_rule_form_if_condition", with: "朝起きたら"
      fill_in "if_then_rule_form_then_action", with: "腕立て伏せ3回する"
      check "commit_type"

      find("summary", text: "曜日の繰り返し設定").click
      check "月曜日"
      check "火曜日"
      check "水曜日"
      check "木曜日"
      check "金曜日"
      check "土曜日"
      check "日曜日"

      click_button "保存する"

      visit if_then_rules_path
      expect(page).to have_content("If-Thenルール一覧")
      expect(page).to have_content("毎日")
    end
  end


end