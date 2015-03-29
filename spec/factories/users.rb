FactoryGirl.define do
  factory :user do
    name 'John'

    factory :user_with_current_deck do
      association :current_deck, factory: :deck
    end
  end
end