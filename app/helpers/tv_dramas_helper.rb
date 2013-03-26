# coding: utf-8
module TvDramasHelper

  def play_tag(tv, download)
    vod_url = play_tv_drama_download_path(tv, download)
    link_to vod_url, :class => 'vod', :target => '_blank', :title => "在线播放", :rel => 'tipsy' do
      raw(%(<i class="icon icons_play"></i>))
    end
  end

  def lixian_tag(tv, download)
    return '' if download.nil?
    link_to lixian_tv_drama_download_path(tv, download), :class => 'vod', :target => '_blank', :title => "迅雷离线", :rel => 'tipsy' do
      raw(%(<i class="icon icons_download"></i>))
    end    
  end

  def tv_status(tv_drama)

    if tv_drama.finished?
      link_to tv_drama_path(tv_drama.id), :class => 'finished', :title => "已完结" do
        raw(%(<span>已完结</span>))
      end   
    else
      lastest_season = tv_drama.download_resources.max(:season) rescue nil
      return if lastest_season.nil?
      resource = tv_drama.download_resources.where(:season => lastest_season).desc("episode").first
      if resource && (Time.now - resource.created_at < 1.week)
        link_to tv_drama_path(tv_drama.id), :class => 'newest_update', :title => "" do
          raw(%(<span>更新 S#{resource.season}E#{resource.episode}</span>))
        end         
      end
    end
  end

  def next_episode(pre_releases)
    today = Time.now.end_of_day
    unreleases = pre_releases.select{ |p| p.release_date.end_of_day >= today }
    unreleases.first
  end

end