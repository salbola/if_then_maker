module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then "alert-success"
    when :alert  then "alert-error"
    when :warning then "alert-warning"
    else "alert-info"
    end
  end

  def if_then_rule_board_view(rule)
    safe_join([
      tag.p(rule.if_condition, class: "font-normal"),
      tag.p(rule.then_action, class: "font-semibold text-primary mt-4")
    ])
  end
#新規作成でその時のactiveなルールの個数でステータスのフォームとしてのデフォルト値を変える
  def change_default_status(active_if_then_rules,setted_status:nil)
    #もしすでに設定済みの値があればそれを返す(warningやerrorによる再表示用)
    return setted_status if setted_status
    #activeなルールの個数が3つ以上あれば初期値をdraftにする
    active_if_then_rules.length >= 3 ? "draft" : "active"

  end

  # 今後以下のような表現方法を切り替える機能があると良いかもしれない
  # def if_then_rule_board_view(rule, style: :default)
  # case style
  # when :default
  #   "もし#{rule.if_condition}なら、#{rule.then_action}"
  # when :monologue
  #   "#{rule.if_condition}になったら、#{rule.then_action}しよう"
  # when :question
  #   "#{rule.if_condition}のとき、#{rule.then_action}する？"
  # end
  # end
end
