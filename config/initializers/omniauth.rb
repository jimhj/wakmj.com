Rails.application.config.middleware.use OmniAuth::Builder do
  require 'weibo'
  provider :weibo, Setting.weibo_key, Setting.weibo_secret
end