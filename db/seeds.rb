# http://www.hearthhead.com/data=hearthstone-cards
    
# Heroes
#   1 => Warrior
#   2 => Paladin
#   3 => Hunter
#   4 => Rogue
#   5 => Priest
#   7 => Shaman
#   8 => Mage
#   9 => Demonist
#   11 => Druid

Hero.create(class_name: 'Warrior', remote_id: 1, name: 'Garrosh Hellscream')
Hero.create(class_name: 'Paladin', remote_id: 2, name: 'Uther Lightbringer')
Hero.create(class_name: 'Hunter', remote_id: 3, name: 'Rexxar')
Hero.create(class_name: 'Rogue', remote_id: 4, name: 'Valeera Sanguinar')
Hero.create(class_name: 'Priest', remote_id: 5, name: 'Anduin Wrynn')
Hero.create(class_name: 'Shaman', remote_id: 7, name: 'Thrall')
Hero.create(class_name: 'Mage', remote_id: 8, name: 'Jaina Proudmoore')
Hero.create(class_name: 'Demonist', remote_id: 9, name: 'Gul\'dan')
Hero.create(class_name: 'Druid', remote_id: 11, name: 'Malfurion Stormrage')

json = ActiveSupport::JSON.decode(File.read(File.dirname(__FILE__) + '/cards.json'))

json.each do |c|
  Card.create({
    :id => c['id'],
    :set => c['set'],
    :quality => Card.i_to_quality(c['quality'].to_i),
    :type_id => c['type'],
    :health => c['health'],
    :attack => c['attack'],
    :hero_id => c['classs'],
    :faction => c['faction'],
    :cost => c['cost'],
    :elite => c['elite'],
    :collectible => c['collectible'],
    :description => c['description'],
    :name => c['name'],
    :popularity => c['popularity']
  })
end

baseCards = Card.where(set: 2, hero_id: nil)
mageCards = Card.joins(:hero).where(heroes: { class_name: 'Mage' })
twiceBaseCards = baseCards + baseCards
User.create(name: 'Arnaud', cards: twiceBaseCards + mageCards)
User.create(name: 'Sebastien', cards: twiceBaseCards)
User.create(name: 'Bla', cards: mageCards)
