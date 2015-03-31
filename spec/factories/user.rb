FactoryGirl.define do
  factory :user do
    name 'John'

    trait :with_uncompleted_deck do
      after(:create) do |user|
        user.decks << create(:deck_uncompleted)
      end
    end

    trait :with_completed_deck do
      after(:create) do |user|
        user.decks << create(:deck_completed)
      end
    end
  end
end