# coding: utf-8
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wakmj::Application.initialize!
SITE_NAME = "#{Setting.app_name} - 美剧迷社区 - 行尸走肉第三季 - 吸血鬼日记 - 生活大爆炸 - 最新美剧 - 美剧 - 美剧下载"
# $redis.reconnect