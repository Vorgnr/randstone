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
    :elite => c['elite'],
    :collectible => c['collectible'],
    :description => c['description'],
    :name => c['name'],
    :popularity => c['popularity']
  })
end

User.create(name: 'Sebastien')
User.create(name: 'Arnaud', cards: [Card.new(id: 5)])
