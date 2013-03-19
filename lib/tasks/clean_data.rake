# coding: utf-8
namespace :wakmj do
  desc "clean tv dramas' download resources"
  task :clean_data => :environment do
    i = 1

    # ActiveRecord::Base.transaction do

      TvDrama.all.each do |tv|
        tv.download_resources.each do |dr|
          begin
            dr.season = dr.season.delete("S")
            dr.episode = dr.episode.delete("E")
            dr.save!
            p "reset #{i}"
            i += 1
          rescue => e
            p e.inspect
            next
          end  
        end
      end

    # end

  end
end