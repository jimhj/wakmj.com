Rails.application.config.middleware.use OmniAuth::Builder do
  require 'weibo'
  require 'renren'
  provider :weibo, Setting.weibo_key, Setting.weibo_secret
  provider :renren, Setting.renren_key, Setting.renren_secret
end