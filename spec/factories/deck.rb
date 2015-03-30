FactoryGirl.define do
  factory :deck do
    name 'dummy'

    factory :deck_with_picked_heroes do
      status 'pick_hero'
      hero_a_id 1
      hero_b_id 2
      hero_c_id 3
    end
  end
end