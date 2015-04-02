FactoryGirl.define do
  factory :card do
    trait :with_base_quality do
      quality 'base'
    end

    trait :with_common_quality do
      quality 'common'
    end

    trait :with_rare_quality do
      quality 'rare'
    end

    trait :with_epic_quality do
      quality 'epic'
    end

    trait :with_legendary_quality do
      quality 'legendary'
    end
  end
end