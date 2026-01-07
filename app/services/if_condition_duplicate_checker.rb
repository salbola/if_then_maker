class IfConditionDuplicateChecker
  def self.check(user:, if_condition:)
    return [] if if_condition.blank?

    if user.if_then_rules.exists?(if_condition: if_condition)
      [ "すでに同じ IF 条件の習慣が存在します。" ]
    else
      []
    end
  end
end
