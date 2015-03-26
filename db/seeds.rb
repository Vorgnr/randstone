# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

json = ActiveSupport::JSON.decode(File.read(File.dirname(__FILE__) + '/cards.json'))

json.each do |c|
  Card.create({
    :id => c['id'],
    :set => c['set'],
    :quality => c['quality'],
    :type_id => c['type'],
    :health => c['health'],
    :attack => c['attack'],
    :class_id => c['classs'],
    :faction => c['faction'],
    :cost => c['cost'],
    :elite => c['elite'],
    :collectible => c['collectible'],
    :description => c['description'],
    :name => c['name'],
    :popularity => c['popularity']
  })
end

baseCards = Card.where(set: 2)
twiceBaseCards = baseCards + baseCards
User.create(name: 'Arnaud', cards: twiceBaseCards)
User.create(name: 'Sebastien', cards: twiceBaseCards)
