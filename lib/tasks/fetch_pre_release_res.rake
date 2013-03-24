# coding: utf-8
require 'nokogiri'
require 'open-uri'
namespace :parse do

  desc "get tv_dramas pre release resources from  yyets.com"

  task :pre_release => :environment do
    year = 2013
    months = [03, 04, 05]
    init_n = 1
    u_a = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.12 Safari/537.31"
    months.each do |month|
      begin
        dom = Nokogiri::HTML open(remote_url(:year => year, :month => month), "User-Agent" => u_a)
        dom.at('table.playTime_tv').css('td.ihbg, td.cur').css('dl').each_with_index do |ele, i|
          d =  ele.at('dt').content.scan(/\d{1,2}/).first.to_i
          datetime = "#{year}#{'%02d' % month}#{ '%02d' % d }"  
          # p ele
          p datetime
          dd_dom = ele.css('dd').each_with_index do |_ele, _i|
            opts = {}
            link = _ele.at('a')
            if link.present?
              tv_name = link.css('.fa1').first.content
              p "#{tv_name} ==================>"
              pre_v = link.css('.fa1').last.content
              p pre_v
              opts[:season] = pre_v.scan(/S(\d{2,2})/).flatten.first || '01'
              opts[:episode] = pre_v.scan(/E(\d{2,2})/).flatten.first || '01'
              opts[:release_date] = datetime.to_datetime
              tv_drama = TvDrama.any_of(:tv_name => /#{tv_name}/).first
              if tv_drama.present?
                if tv_drama.pre_releases.where(season: opts[:season], episode: opts[:episode]).blank?
                  tv_drama.pre_releases.create!(opts)
                  init_n += 1
                  p "create #{init_n}"
                end
              end
            end
          end
        end
      rescue Exception => e
        p e.inspect
      end
    end
  end

  def remote_url(time)
    time[:year] ||= 2012
    time[:month] ||= 10
    # url = "http://www.yyets.com/tv/schedule/index/year/#{time[:year]}/month/#{time[:month]}"
    url = "http://www.yyets.com/tv/schedule/index/year/#{time[:year]}/month/#{'%02d' % time[:month]}"
    p url
    url
  end
end
