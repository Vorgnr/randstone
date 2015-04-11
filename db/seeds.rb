# http://www.hearthhead.com/data=hearthstone-cards
# http://wow.zamimg.com/images/hearthstone/cards/enus/medium/EX1_350.png
   
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

Hero.create(class_name: 'Warrior', id: 1, name: 'Garrosh Hellscream')
Hero.create(class_name: 'Paladin', id: 2, name: 'Uther Lightbringer')
Hero.create(class_name: 'Hunter', id: 3, name: 'Rexxar')
Hero.create(class_name: 'Rogue', id: 4, name: 'Valeera Sanguinar')
Hero.create(class_name: 'Priest', id: 5, name: 'Anduin Wrynn')
Hero.create(class_name: 'Shaman', id: 7, name: 'Thrall')
Hero.create(class_name: 'Mage', id: 8, name: 'Jaina Proudmoore')
Hero.create(class_name: 'Demonist', id: 9, name: 'Gul\'dan')
Hero.create(class_name: 'Druid', id: 11, name: 'Malfurion Stormrage')

json = ActiveSupport::JSON.decode(File.read(File.dirname(__FILE__) + '/cards.json'))
card_count = json.length

json.each do |c, i|
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
    :popularity => c['popularity'],
    :image => c['image']
  })
end

baseCards = Card.where(quality: 'base')
arnaud = User.create! :name => 'arnaud', :email => 'arnaud@test.com', :password => '12345678', :password_confirmation => '12345678'
arnaud.cards << baseCards + baseCards
