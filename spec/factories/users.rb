FactoryGirl.define do
  factory :user do
    name "John"
    current_deck_id nil
  end

  factory :user_with_pending_deck do
    name "John"
    current_deck_id 5
  end
end