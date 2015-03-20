json.array!(@cards) do |card|
  json.extract! card, :id, :set, :quality, :type_id, :cost, :health, :attack, :faction, :class_id, :elite, :collectible, :name, :description, :popularity
  json.url card_url(card, format: :json)
end
