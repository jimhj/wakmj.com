require 'nokogiri'
require 'open-uri'

namespace :parse do

  desc "get tv_dramas data from  yyets.com"

  task :yyets => :environment do
    # TODO: Mark where does the loop ended at. 
    # unreadable code.
    i = j = 0
    1.upto(30).each do |page|
      p "start scraping articles on page #{j + 1}..."
      dom = Nokogiri::HTML open(res_url(page))

      html_str = dom.at('div.res_listview')

      fetch_urls = html_str.css('ul.boxPadd.dashed li a.imglink').collect do |ele|
        ele.attribute_nodes.last.value
      end

      fetch_urls.each do |url|
        begin
          d_dom = Nokogiri::HTML open(url)

          new_drama = scrap_drama_res(d_dom)

          scrap_download_res(new_drama, d_dom)


          i += 1
          puts "Record added."
        rescue Exception => e
          j += 1
          puts e.inspect
        end
        sleep(1)
      end

      # drama_ids = dom.xpath('//div[starts-with(@id, "collect_form_")]').collect do |ele|
      #   ele.attributes['id'].value.delete('collect_form_') 
      # end

    end
    puts "#{i} succeed.   #{j} failed."
  end

  def res_url(page = 1)
    # "http://www.yyets.com/php/resourcelist?channel=tv&area=%E7%BE%8E%E5%9B%BD&category=&format=&sort=pubdate"
    "http://www.yyets.com/php/resourcelist?page=#{page}&channel=tv&area=%E7%BE%8E%E5%9B%BD&category=&format=&sort=pubdate"
  end

  def scrap_drama_res(d_dom)
    tv_drama = {}
    tv_drama[:tv_name] = d_dom.at('h2.tv').children[0].children[0].content
    detail_dom = d_dom.at('div.res_infobox')
    tv_drama[:remote_cover_url] = detail_dom.at('div.f_l_img').css('a')[0].attributes['href'].value
    summary_dom = detail_dom.at('ul.r_d_info').css('li')
    tv_drama[:category_list] = summary_dom[0].children[-1].content
    tv_drama[:tv_station] = summary_dom[0].children[1].content        
    tv_drama[:release_date] = summary_dom[2].children[-1].content.to_datetime
    tv_drama[:summary] = summary_dom[-1].at('div').content

    # due to the yyets.com.
    if summary_dom.size == 6
    elsif summary_dom.size == 10
      tv_drama[:alias_name_list] = summary_dom[4].children[-1].content
      tv_drama[:actor_list] = summary_dom[-4].children[-1].content
    end

    tv_drama[:verify] = true
    tv_drama.each_pair { |k, v| v.strip! if v.is_a?(String) }

    if TvDrama.any_of(:tv_name => /#{tv_drama[:tv_name]}/).blank?
      new_drama = TvDrama.create!(tv_drama)
    end
    
  end


  def scrap_download_res(drama, from_dom)
    begin
      p "start scraping download resources..."
      resource = {}
        download_dom = from_dom.css('ul.resod_list li').xpath('//li').collect do |li|
      # download_dom = from_dom.css('ul.resod_list li').xpath('//li[@format="720P"]').collect do |li|
        info = li.at('span.l a')

        if info
          resource[:link_text] = info.attribute_nodes.last.value
          resource[:episode_format] = info.child.content
          resource[:episode_size] = info.children.last.content
          resource[:season] = resource[:link_text].scan(/S\d{2,2}/).first || 'S01'
          resource[:episode] = resource[:link_text].scan(/E\d{2,2}/).first || 'E01'

          link = li.at('span.r a').xpath(%Q(//a[@thunderrestitle="#{resource[:link_text]}"])).first
          resource[:download_link] = link.attribute_nodes.last.value  if link
          # drama.download_resources.create!(resource)
          if drama.download_resources.where(:season => resource[:season], :episode => resource[:episode], :episode_format => resource[:episode_format]).blank?
            drama.download_resources.create!(resource)
          end
        end
      end
    rescue Exception => e
      p e.inspect
      puts "scrap download resources failed."
    end
  end

end