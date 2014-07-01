FactoryGirl.define do
  factory :user do
    name 'John Doe'
    email 'john.doe@gmail.com'
    uid { 'abcd' } #TODO: generate random string here
  end
end
