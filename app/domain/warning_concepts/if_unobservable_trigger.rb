module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class IfUnobservable_trigger
    def self.definition
      {
        label: "気付けるトリガーになっている",
        description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態",
        hint: "自分の気分や状態ではなく、外から確認できる出来事になっている ",
        patterns: {
          emotional_state_trigger: {
            matchers: [ "やる気", "やるき",  ],
            reason: "感情は客観的に気が付きにくく実行条件として機能しないかもしれません。",
            suggestion: "物理的な状況や行動に置き換えてみましょう。",
            example: "例：「やる気が出たら」→「心拍数が上がったら」"
          }
        }
      }
    end
  end
end