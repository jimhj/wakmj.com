# coding: utf-8
namespace :wakmj do
  desc "clean tv dramas' download resources"
  task :clean_data => :environment do
      TvDrama.all.each do |tv|
        tv.download_resources_count = tv.download_resources.count rescue 0
        tv.save
      end

      PreRelease.destroy_all
  end
end