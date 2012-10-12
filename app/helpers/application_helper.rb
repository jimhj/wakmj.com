# coding: utf-8

module ApplicationHelper

  def fancy_tag(likeable)

    icon = %Q(<i class="icon icons_fancy"></i>)

    like_lable = likeable.liked_by_user?(current_user) ? '已喜欢' : '喜欢'

    link = %Q(
      <a href="javascript:;" class="like_it" data-likeable_type="#{likeable.class.to_s}" data-likeable_id="#{likeable.id}" data-liked=#{likeable.liked_by_user?(current_user)}>
        #{like_lable}
        <span>(#{likeable.likes_count})</span>
      </a>
    )
    raw(icon + link)
  end


  def replace_at_sym(text)
    return '' if text.blank?
    user_names = text.scan(/@(.[^\s]{1,20})/).flatten
    user_names.each do |user_name|
      _u = '@' + user_name
      text[_u] = link_to(_u, user_path(user_name))
    end
    text.html_safe
  end
  
  def render_page_title
    title = @page_title ? "#{@page_title} | #{SITE_NAME}" : SITE_NAME rescue "SITE_NAME"
    content_tag("title", title, nil, false)
  end      

end
