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

    trait :with_pick_hero_deck do
      after(:create) do |user|
        user.decks << create(:deck_pick_hero)
      end
    end

    trait :with_heroes_picked_deck do
      after(:create) do |user|
        user.decks << create(:deck_with_heroes_picked)
      end
    end
  end
end