module Warnings
  class IfDuplicateContentChecker
    def self.check(user:, if_condition:, exclude_id: nil)
      return [] if if_condition.blank?

      scope = user.if_then_rules.where(if_condition: if_condition)
      # 無視するべきIDを取り除く
      scope = scope.where.not(id: exclude_id) if exclude_id

      if scope.exists?
        [ {
          field: :if_condition,
          message: "すでに同じ IF 条件の習慣が存在します。"
        } ]
      else
        []
      end
    end
  end
end
