# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.dsn = ENV['SENTRY_DSN']
  config.traces_sample_rate = 1.0
  # Rails 7のエラーレポーターの使用（これで自動検知が強力に）
  config.rails.register_error_subscriber = true
  # 環境の情報をみれるようになる
  config.environment = Rails.env
  # 特定環境のみ
  # config.enabled_environments = %w[production]
end
