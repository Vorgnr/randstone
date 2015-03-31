FactoryGirl.define do
  factory :hero do
    name ('a'..'z').to_a.shuffle.join
  end
end