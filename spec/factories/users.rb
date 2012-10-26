FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "user-#{Time.now.to_i.to_s}@wakmj.com" }
    sequence(:login) { |n| "login-#{Time.now.to_i.to_s}" }
    password 'password'
    password_confirmation 'password'
  end


  factory :superadmin, :parent => :user do
    roles ["member", "superadmin"]
  end

  # factory :wiki_editor, :parent => :user

  # factory :non_wiki_editor, :parent => :user do
  #   verified false
  # end
end