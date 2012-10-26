FactoryGirl.define do
  

  factory :tv_drama do
    sequence(:tv_name) { |n| "The Test Drama-#{Time.now.to_i.to_s}" }
    # cover "http://www.test.com/2.jpg"
    verify true
  end


end