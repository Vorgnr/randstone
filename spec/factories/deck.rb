FactoryGirl.define do
  factory :deck do
    name 'dummy'

    factory :deck_with_heroes_picked do
      name 'deck_with_picked_heroes'
      status 'hero_picked'
    end

    factory :deck_uncompleted do
      name 'deck_uncompleted'
      status 'pick_hero'
    end

    factory :deck_pick_hero do
      name 'deck_pick_hero'
      status 'pick_hero'
    end

    factory :deck_completed do
      name 'deck_completed'
      status 'completed'
    end
  end
end