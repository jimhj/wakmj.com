# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Init super admin:
super_admin = User.new({
  :login => 'laohuang',
  :email => 'bzu_2007@126.com',
  :password => '123456',
  :password_confirmation => '123456',
  :roles => ['superadmin']
})

super_admin.save!

# Init tv drama categories:

cates = %w(动作 战争 剧情 喜剧 生活 偶像 青春 魔幻 科幻 历史 纪录 暴力 血腥 歌舞 恐怖 惊悚 悬疑 古装 史诗 丧尸 爱情 医务 律政 真人秀 励志 体育 谍战 罪案 冒险 动画 科教 西部 枪战 灾难 传记)

cates.each do |c|
  TvCategory.create(name:c)
end