module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class ThenNegativeExpressionAction
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "実行しにくい否定表現でなく別の肯定の表現にする'代替ifthen'",
        description: "脳の特性や行動心理学的に、「回避」や「禁止」の指示は行動に繋がりにくく、むしろその対象を意識させてしまう。(シロクマ効果)「したくない行動の代わりにxxxxする」にという形式が良い。'代替ifthen'",
        hint: "「〜しない」ではなく、やる行動で書かれている",
        patterns: {
          negative_expression_action: {
            matchers: [
            "しない","やらない","禁止","きんし","だめ","ダメ","駄目","はx","やめる","止める","ない","せぬ","ません","やらん"
            ],
            reason: "脳の特性的に、「回避」や「禁止」の指示は行動に繋がりにくく、むしろその対象を意識してしまいます。",
            suggestion: "肯定的な行動の方が、行動へ自動的に移りやすいです。 ",
            example: "例：「夜食を食べない」→「夜食が食べたくなったら、歯を磨く」"
          },

        }
      }
    end
  end
end
