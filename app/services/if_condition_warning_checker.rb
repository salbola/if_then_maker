class IfConditionWarningChecker
  WARNING_KEYWORDS = {
    "常に" => "『常に』は行動のきっかけとして曖昧になりやすいです。",
    "いつも" => "『いつも』は具体的なタイミングに言い換えると効果的です。",
    "毎回" => "『毎回』は条件として弱くなりがちです。"
  }.freeze

  def self.check(text)
    return [] if text.blank?

    WARNING_KEYWORDS.filter_map do |warning_keyword, warning_message|
      warning_message if text.include?(warning_keyword)
    end
  end
end