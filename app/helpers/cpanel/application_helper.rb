# coding: utf-8

module Cpanel::ApplicationHelper

  def nav_tab_tag(*links)
    li_tags = links.collect do |link|
      %Q(<li class=#{(url_for == link[0] || link[2]) ? 'active' : nil}><a href="#{link[0]}">#{link[1]}</a></li>)
    end.join.html_safe
    content_tag 'ul', :class => 'nav nav-tabs' do
      li_tags
    end.html_safe
  end
end