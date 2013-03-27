# coding: utf-8
namespace :post_to do
  desc "每日9点定时随机推荐美剧到新浪微博"
  task :weibo => :environment do
    begin
      tv = TvDrama.all.sample
      pic_path = File.join(Setting.pic_loc, tv.cover_url(:large))
      tv_url = "#{Setting.site_url}tv_dramas/#{tv.id}"
      token = User.where(:email => "wahaha@sina.com.cn").first.weibo_token
      summary = (tv.summary || '').truncate(60)
      status = %Q(每日美剧推荐: #{tv.tv_name} #{tv_url} #{summary} @美剧微吧)

      conn = Faraday.new(:url => 'https://upload.api.weibo.com') do |faraday|
        faraday.request :multipart
        faraday.adapter :net_http
      end

      conn.post "/2/statuses/upload.json", {
        :access_token => token,
        :status => URI.encode(status),
        :pic => Faraday::UploadIO.new(pic_path, 'image/jpeg')
      }
    rescue => e
    end
  end
end