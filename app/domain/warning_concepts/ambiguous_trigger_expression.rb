module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class AmbiguousTriggerExpression
    def self.definition
      {
        label: "曖昧表現の回避",
        description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態",
        hint: "「いつも・そのうち」など曖昧な言葉を使っていない ",
        description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態です",
        patterns: {
          always_expression: {
            matchers: ["常に", "つねに"],
            reason: "例外を含みやすく、実行条件として曖昧になりがちです。",
            suggestion: "具体的な状況や行動に置き換えてみましょう。",
            example: "例：「常に疲れたら」→「仕事から帰宅して椅子に座ったら」"
          }
        }
      }
    end
  end
end