# coding: utf-8
namespace :post_to do
  desc "每日定时随机推荐美剧到新浪微博和人人网"
  task :weibo => :environment do
      # tv = TvDrama.all.sample(1).first
      tv = find_tv
      pic_path = File.join(Setting.pic_loc, tv.cover_url(:large))
      tv_url = "#{Setting.site_url}tv_dramas/#{tv.id}"
      summary = (tv.summary || '').truncate(100)
        
    begin
      p "=====================================>开始定时发微博到新浪"
      token = User.where(:weibo_uid => "3227694005").first.try(:weibo_token) || "2.00jeE8WD0gTPtJc0c7397746viTO7D"
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
      p "定时发微博到新浪失败<========================================"
    end

    begin
      p "=====================================>开始定时发微博到人人"
      r_token = User.where(:renren_uid => "231291271").first.try(:renren_token)
      r_status = %Q(每日美剧推荐: #{tv.tv_name} #{tv_url} #{summary})

      r_conn = Faraday.new(:url => 'https://api.renren.com') do |faraday|
        faraday.request :multipart
        faraday.response :logger
        faraday.request :url_encoded
        faraday.adapter :net_http
      end

      ret = r_conn.post 'restserver.do', {
        :access_token => r_token,
        :method => "photos.upload",
        :v => '1.0',
        :format => 'json',
        :page_id => '699230428',
        :aid => '864916258',
        :caption => r_status,
        :upload => Faraday::UploadIO.new(pic_path, 'image/jpeg')
      }

    rescue => e
      p "定时发微博到人人失败<========================================"
    end    
  end

  def find_tv
    tv_id = 1.upto(999).to_a.sample
    tv = TvDrama.find_by_id tv_id
    if tv.present?
      return tv
    else
      find_tv
    end
  end
end