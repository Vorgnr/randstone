json.array!(@cards) do |card|
  json.extract! card, :id, :image
  json.image image_path(medium_card_image_path(card.image))
end