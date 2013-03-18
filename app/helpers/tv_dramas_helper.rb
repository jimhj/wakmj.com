# coding: utf-8
module TvDramasHelper

  def play_tag(download_link = nil)
    return '' if download_link.nil?
    title = signed_in? ? "迅雷点播，需要有迅雷会员" : '请先登录'
    vod_url = signed_in? ? "#{Setting.xunlei_vod_url}#{download_link}" : 'javascript:;'
    link_to vod_url, :class => 'vod', :title => title do
      raw(%(<i class="icon icons_play"></i>))
    end
  end

  def download_link_tag(res)
    download_url = signed_in? ? res.download_link : 'javascript:;'
    title = signed_in? ?  '点击下载' : '登录后可点击下载'
    link_to res.link_text, download_url, :class => 'download_link', :title => title
  end

  def tv_status(tv_drama)
    if tv_drama.finished?
      link_to tv_drama_path(tv_drama.id), :class => 'finished', :title => "已完结" do
        raw(%(<span>已完结</span>))
      end   
    else
      resource = tv_drama.download_resources.desc('created_at').first
      if resource && (Time.now - resource.created_at < 1.week)
        link_to tv_drama_path(tv_drama.id), :class => 'newest_update', :title => "更新至" do
          raw(%(<span>更新#{resource.season}#{resource.episode}</span>))
        end         
      end
    end
  end

end