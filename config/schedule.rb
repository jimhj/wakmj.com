# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "/home/deploy/www/wakmj/current/log/#{Time.now.strftime('%F')}.crontab.log"
set :environment, 'production' 
every :day, :at => '00:01am' do
  rake "parse:yyets"
  rake "sitemap:clean"
  rake "sitemap:create"
end

every :day, :at => '09:00am' do
  rake "post_to:weibo"
end

every :day, :at => '15:00pm' do
  rake "post_to:weibo"
end

every :day, :at => '19:00pm' do
  rake "post_to:weibo"
end