module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice then "alert-success"
    when :alert  then "alert-error"
    when :warning then "alert-warning"
    else "alert-info"
    end
  end

  def if_then_rule_board_view(rule_object)
    "もし#{rule_object.if_condition}なら#{rule_object.then_action}する"
  end
end
