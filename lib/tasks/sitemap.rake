# coding: utf-8
require 'builder'
namespace :g do
  domain = "http://www.wakmj.com/"
  desc 'Generate wakmj.com sitemap files.'
  task :sitemap => :environment do
    puts "Creating sitemap.xml ..."

    tv_dramas = TvDrama.desc('created_at').limit(10000)
    articles = Article.desc('created_at').limit(10000)
    topics = Topic.desc('created_at').limit(10000)
    users = User.desc('created_at').limit(10000)
    
    file = File.new('public/sitemap.xml', 'w')
    xml = Builder::XmlMarkup.new(:target => file, :indent => 2)
    xml.instruct!
    xml.urlset(
      :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
      'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
      'xsi:schemaLocation' => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
    ) {

      tv_dramas.each do |tv_drama|
        xml.url {
          xml.loc("#{domain}tv_dramas/#{tv_drama.id}")
          xml.changefreq('always')
        }
      end

      articles.each do |arti|
        xml.url {
          xml.loc("#{domain}articles/#{arti.id}")
          xml.changefreq('always')
        }      
      end

      topics.each do |topic|
        xml.url {
          xml.loc("#{domain}topics/#{topic.id}")
          xml.changefreq('always')
        }      
      end

      users.each do |user|
        xml.url {
          xml.loc("#{domain}#{user.login}")
          xml.changefreq('always')
        }      
      end

    }
    xml.target!
    file.close

    puts "Creating sitemap.html ..."
    html_file = File.new('public/sitemap.html', 'w')
    html = Builder::XmlMarkup.new(:target => html_file, :indent => 2)
    html.declare!(:DOCTYPE, :html, :PUBLIC, "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd")
    html.html {

      html.head {
        html.title('Sitemap - wakmj.com')
        html.meta('http-equiv' => 'Content-type', :content => 'text/html; charset=utf-8')
      }

      html.body {

        tv_dramas.each do |tv_drama|
          html.p {
            html.a(:href => "#{domain}tv_dramas/#{tv_drama.id}", :title => tv_drama.tv_name) { html.text!(tv_drama.tv_name) }
          }
        end

        articles.each do |arti|
          html.p {
            html.a(:href => "#{domain}articles/#{arti.id}", :title => arti.title) { html.text!(arti.title) }
          }     
        end

        topics.each do |topic|
          html.p {
            html.a(:href => "#{domain}topics/#{topic.id}", :title => topic.title) { html.text!(topic.title) }
          }         
        end  

        users.each do |user|
          html.p {
            html.a(:href => "#{domain}#{user.login}", :title => user.login) { html.text!(user.login) }
          }      
        end                       
      }

    }

    html.target!
    html_file.close

  end
end
