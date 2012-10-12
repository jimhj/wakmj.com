require 'nokogiri'
require 'open-uri'
namespace :parse do

  desc "get articles from  yyets.com"

  task :articles => :environment do

    begin
      i = 1
      j = 1
      1.upto(20).each do |page|
        p "start scraping articles on page #{j}..."
        dom = Nokogiri::HTML open(art_url(page))
        dom.at('div.topicList').css('ul li.clearfix').each do |art_dom|
          tit_dom = art_dom.at('div.f_r_info h3 a')
          summary = art_dom.children[-2].children[-3].content
          link = tit_dom.attributes['href'].value
          title = tit_dom.content

          detail_dom = Nokogiri::HTML open(link)

          tv_name = detail_dom.at('ul.relateImg li.dot a:last').content.strip
          art_content = detail_dom.at('div#news_content').content

          tv_drama = TvDrama.any_of(:tv_name => /#{tv_name}/).first
          if tv_drama.present?
            begin
              tv_drama.articles.create!(title: title, content: art_content, summary: summary, from: link, source_link: link)
              p "#{i} articles added."
              i += 1
            rescue => e
              p e.inspect
            end
          end
        end
        j += 1
      end  
    rescue Exception => e
      p e.inspect
    end
  end

  def art_url(page = 1)
    "http://www.yyets.com/php/news?page=#{page}&type=review&channel=tv"
  end
end
