class Hero < ActiveRecord::Base
  def self.random_trio
    heroes = self.all
    puts ' heros =>  ' + heroes[0].inspect
    return [heroes[0], heroes[1], heroes[3]]
  end
end
