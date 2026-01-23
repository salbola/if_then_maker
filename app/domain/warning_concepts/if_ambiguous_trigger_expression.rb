module WarningConcepts
  # zeit werkがキャメルケースで予測するらしいので全文字が大文字になる定数でなくキャメルケースになるクラスを使用することにした
  class IfAmbiguousTriggerExpression
    def self.concept_key
      name.demodulize.underscore.to_sym
    end

    def self.definition
      {
        label: "開始タイミングが絞れること",
        target: :if,
        description: "実行条件が曖昧で、行動のきっかけとして再現性が低い状態",
        hint: "その瞬間が起きたと直感的に1つに判断できる ",
        patterns: {
          always_expression: {
            matchers: [ "常に", "つねに", "いつも", "何時も", "毎回", "まいかい", "永遠に", "えいえんに", "永久に", "えいきゅうに", "日頃から", "ひごろから", "日常", "にちじょう" ],
            reason: "当てはまる状況が多すぎて実行条件として機能しないかもしれません。",
            suggestion: "具体的な状況や行動に置き換えてみましょう。",
            example: "例：「常に」→「仕事から帰宅して椅子に座ったら」"
          },

          never_come_time_expression: {
            matchers: [
              "そのうち", "その内",
              "いずれ", "何れ",
              "後で", "あとで",
              "できるなら",
              "できれば",
              "可能なら", "かのうなら",
              "必要になったら", "ひつようになったら",
              "タイミングを見て",
              "様子を見て",
              "時間があれば", "じかんがあれば",
              "暇なとき", "ひまなとき"
            ],
            reason: "発生タイミングが不明確で、行動が先延ばしになりやすい表現です。",
            suggestion: "具体的に『何が起きたら』行うのかを決めてみましょう。",
            example: "例：「そのうちやる」→「帰宅してカバンを置いたらやる」"
          },

          only_vague_time_expression: {
            matchers: [
              # これは後ほど正規表現にするべき案件
              # "朝", "夜",
              # "午前中", "午後",
              # "中に"
            ],
            reason: "時間帯は示されていますが、開始の瞬間が特定できません。",
            suggestion: "その時間帯の中で、最初に起きる具体的な出来事に置き換えましょう。",
            example: "例：「朝にやる」→「朝、カーテンを開けたらやる」"
          }
        }
      }
    end
  end
end
