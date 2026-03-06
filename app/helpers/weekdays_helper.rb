module WeekdaysHelper
  # 毎日か設定されている曜日を配列に入れて返す
  # 空配列の場合"毎日"というところも対応
  def weekdays_labels(weekdays)
    return ["毎日"] if weekdays.blank?

    t_names = I18n.t("date.abbr_day_names")

    weekdays.map {|i| t_names[i]}
  end
# 曜日の色の管理するハッシュから対応するクラス文字列を返す
  def weekdays_bg_color(day)
    {
      "日" => "bg-red-100 text-red-700",
      "月" => "bg-blue-100 text-blue-700",
      "火" => "bg-orange-100 text-orange-700",
      "水" => "bg-cyan-100 text-cyan-700",
      "木" => "bg-emerald-100 text-emerald-700",
      "金" => "bg-yellow-100 text-yellow-700",
      "土" => "bg-purple-100 text-purple-700",
      "毎日" => "bg-slate-500 text-white"
    }.fetch(day, "bg-base-200")
  end
end