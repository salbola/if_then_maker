module Warnings
  class StatusTooManyActiveChecker
    LIMIT = 3
    CONCEPT = WarningConcepts::StatusTooManyActive
    # currnt_ruleがnilの場合新規作成としてるのでこれだけは必須ではない
    def self.check(user:, status:, current_rule: nil)
      # 新規作成時 : activeではない ならスキップ
      return [] unless status&.to_sym == :active
      # 編集時：すでに active ならスキップ
      return [] if current_rule&.status&.to_sym == :active

      concept_key = CONCEPT.concept_key
      concept = CONCEPT.definition
      pattern_key = concept[:patterns].keys.first
      pattern = concept[:patterns][pattern_key]




      active_count = user.if_then_rules.active.count

      if active_count >= LIMIT
      [ {
            # field: :status,
            # message: "実行中（active）のルールがすでに#{LIMIT}つあります。負担が大きくなっていないか確認してみてください。"
            field: :status,
            concept: concept_key,
            pattern: pattern_key,
            matches: [],
            metadata: {}
      } ]
      else
        []
      end
    end
  end
end
