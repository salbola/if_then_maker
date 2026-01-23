module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class IfDuplicateContent
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "一つのトリガーが一つの行動と結びつく",
        target: :if,
        description: "一つのifに複数の行動が結びついていると選択の余地が出てしまい無意識の行動,習慣化の妨げになる",
        hint: "他のルールと同じ条件になっていない ",
        patterns: {
          duplicate_content: {
            matchers: [ "" ],
            reason: "すでに同じifの習慣が存在します。一つのifに複数の行動が結びついていると迷いが生まれ習慣の妨げになります",
            suggestion: "別のタイミングと結び付けて見ましょう",
            example: "例：「ベッドから出たら布団をたたむ」→「歯を磨いたら布団をたたむ」(もしくは重複しているもう一つを編集する)"
          }

        }
      }
    end
  end
end
