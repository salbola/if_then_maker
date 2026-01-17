module IfThenRulesHelper
  def today_progress(if_then_rules)
    active = if_then_rules.active
    total  = active.count
    done   = active.count(&:reflected_today?)

    {
      total: total,
      done: done,
      percent: total.zero? ? 0 : (done * 100 / total)
    }
  end
end