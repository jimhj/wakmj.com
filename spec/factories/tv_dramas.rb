FactoryGirl.define do
  

  factory :tv_drama do
    sequence(:tv_name) { |n| "The Test Drama-#{Time.now.to_i.to_s}" }
    remote_cover_url "http://tp2.sinaimg.cn/1856138157/180/5636078673/1.jpg"
    verify true
  end


end