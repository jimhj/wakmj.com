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

end
