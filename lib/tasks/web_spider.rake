require 'nokogiri'
require 'open-uri'

namespace :parse do

  desc "get tv_dramas data from  yyets.com"

  task :yyets => :environment do
    # TODO: Mark where does the loop ended at. 
    # unreadable code.

    1.upto(2).each do |page|
      dom = Nokogiri::HTML open(res_url(page))

      html_str = dom.at('div.res_listview')

      fetch_urls = html_str.css('ul.boxPadd.dashed li a.imglink').collect do |ele|
        ele.attribute_nodes.last.value
      end

      fetch_urls.each do |url|
        begin
          tv_drama = {}
          d_dom = Nokogiri::HTML open(url)
          tv_drama[:tv_name] = d_dom.at('h2.tv').children[0].children[0].content
          detail_dom = d_dom.at('div.res_infobox')
          tv_drama[:remote_cover_url] = detail_dom.at('div.f_l_img').css('a')[0].attributes['href'].value
          summary_dom = detail_dom.at('ul.r_d_info').css('li')
          tv_drama[:category_list] = summary_dom[0].children[-1].content
          tv_drama[:tv_station] = summary_dom[0].children[1].content        
          tv_drama[:release_date] = summary_dom[2].children[-1].content.to_datetime
          tv_drama[:summary] = summary_dom[-1].at('div').content

          if summary_dom.size == 6
          elsif summary_dom.size == 10
            tv_drama[:alias_name_list] = summary_dom[4].children[-1].content
            tv_drama[:actor_list] = summary_dom[-4].children[-1].content
          end
          tv_drama[:verify] = true
          TvDrama.create!(tv_drama)
          puts "record was added."
        rescue Exception => e
          puts e.inspect
        end
        sleep(5)
      end

      # drama_ids = dom.xpath('//div[starts-with(@id, "collect_form_")]').collect do |ele|
      #   ele.attributes['id'].value.delete('collect_form_') 
      # end

      # drama_ids[0...1].each do |id|
      #   res = Faraday.get(DOUBAN_API + id)
      #   big_hash = Hash.from_xml(res.body)
      #   p big_hash
      # end
    end
  end

  def res_url(page = 1)
    "http://www.yyets.com/php/resourcelist?page=#{page}&channel=tv&area=%E7%BE%8E%E5%9B%BD&category=&format=&sort="
  end

end