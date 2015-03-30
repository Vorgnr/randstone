FactoryGirl.define do
  factory :user do
    name 'John'

    factory :user_with_current_deck do
      association :current_deck, factory: :deck
    end

    factory :user_with_current_deck_and_pick_hero do
      association :current_deck, factory: :deck_with_picked_heroes
    end
  end
end