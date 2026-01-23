module WarningConcepts
#全てをコンセプトを取得する
  def self.all
    constants
      .map { |const| const_get(const) }
      .select { |c| c.is_a?(Class) }
  end
# 引数でtarget指定してもってくる。targetは:ifや:thenが入る
  def self.concepts_for(target)
  all.select { |c| c.definition[:target] == target }
  end
# targetは:ifや:thenが入る。その種類のwarning_conceptのヒントの中でも有効設定{enabled: true}のものだけ入っている。
  def self.hints_for(target)
    concepts_for(target)
      .select { |c| c.definition.dig(:hint, :enabled) }
  end
end