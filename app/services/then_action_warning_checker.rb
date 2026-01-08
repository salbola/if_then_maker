class ThenActionWarningChecker
  WARNING_KEYWORDS = {
    # 抽象的で完了判定ができない行動
    "考える"     => "完了したかどうかを判断しづらい行動です。",
    "意識する"   => "行動として観測しづらい表現です。",
    "頑張る"     => "成果や完了条件が不明確になりやすい行動です。",
    "気をつける" => "行動ではなく心構えになりやすい表現です。",
    "やる"       => "行動内容が抽象的です。具体的にしてみてください。",
    "する"       => "行動内容が抽象的です。具体的にすると実行しやすくなります。",

    # 行動が大きくなりやすい表現
    "終わらせる" => "行動の範囲が広くなりやすい表現です。最初の一歩に分けてみてください。",
    "完璧にする" => "完了条件が厳しくなりやすい表現です。小さな行動に分けると実行しやすくなります。"
  }.freeze

  def self.check(check_text)
    return [] if check_text.blank?

    WARNING_KEYWORDS.filter_map do |keyword, message|
      message if check_text.include?(keyword)
    end
  end
end