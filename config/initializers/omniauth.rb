Rails.application.config.middleware.use OmniAuth::Builder do
  require 'weibo'
  require 'renren'
  require 'tqq'
  provider :weibo, Setting.weibo_key, Setting.weibo_secret
  provider :renren, Setting.renren_key, Setting.renren_secret
  provider :tqq, Setting.tqq_key, Setting.tqq_secret
end