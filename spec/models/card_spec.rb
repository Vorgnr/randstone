require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '.random_numplet' do
    it 'should return uniq cards nuplet' do
      cards = 50.times.map { create(:card) }
      expect(cards.uniq { |c| c.id }.length).to eq 50
      nuplet = Card.random_nuplet(50, cards)
      u = nuplet.uniq { |c| c.id }
      expect(u.length).to eq 50
    end
  end

  describe '.i_to_quality' do
    it 'should convert integer to Card.quality' do
      expect(Card.i_to_quality(0)).to eq 'base'
      expect(Card.i_to_quality(1)).to eq 'common'
      expect(Card.i_to_quality(2)).to be nil
      expect(Card.i_to_quality(3)).to eq 'rare'
      expect(Card.i_to_quality(4)).to eq 'epic'
      expect(Card.i_to_quality(5)).to eq 'legendary'
      expect(Card.i_to_quality(6)).to be nil
    end
  end

  describe '.random_quality' do
    it 'should return an int or an array of int' do
      quality = Card.random_quality
      result = (quality.is_a? Integer) || quality.all? { |q| q.is_a? Integer }
      expect(result).to be true
    end
  end

  describe '.cards_to_draw' do
    context 'when qualities is nil' do
      it 'should return cards with any qualities' do
        5.times { create(:card, :with_base_quality) }
        5.times { create(:card, :with_common_quality) }
        5.times { create(:card, :with_epic_quality) }
        expect(Card.cards_to_draw.length).to eq 15
      end
    end

    context 'when qualities is not nil' do
      it 'should return cards with expected qualities' do
        5.times { create(:card, :with_base_quality) }
        5.times { create(:card, :with_common_quality) }
        5.times { create(:card, :with_epic_quality) }
        expect(Card.cards_to_draw(qualities: [0, 1]).length).to eq 10
        expect(Card.cards_to_draw(qualities: 4).length).to eq 5
      end
    end

    context 'when hero_id is nil' do
      it 'should return cards with any hero' do
        hero = create(:hero)
        5.times { create(:card, hero: hero) }
        5.times { create(:card) }
        expect(Card.cards_to_draw.length).to eq 10
      end
    end

    context 'when hero_id is not nil' do
      it 'should return cards with expected hero and all cards without any hero' do
        hero = create(:hero)
        hero2 = create(:hero)
        5.times { create(:card, hero: hero) }
        5.times { create(:card, hero: hero2) }
        5.times { create(:card) }
        expect(Card.cards_to_draw(hero_id: hero.id).length).to eq 10
      end
    end

    context 'when user_id is not nil' do
      it "should return user's cards" do
        user = create(:user)
        user2 = create(:user)
        cards = 2.times.map { create(:card) }
        user.cards << cards + cards
        user2.cards << cards
        create(:card)
        expect(Card.cards_to_draw(user_id: user.id).length).to eq 2
      end
    end

    context 'when all parameters are set' do
      it 'should return expected cards' do
        hero = create(:hero)
        user = create(:user)
        bases = 5.times.map { create(:card, :with_base_quality) }
        common = 5.times.map { create(:card, :with_common_quality) }
        common_with_hero= 5.times.map { create(:card, :with_common_quality, hero: hero) }
        epic = 5.times.map { create(:card, :with_epic_quality) }
        epic_with_hero = 1.times.map { create(:card, :with_epic_quality, hero: hero) }
        user.cards << [bases.first, common.first, common_with_hero.first, epic.first, epic_with_hero.first]
        expect(Card.cards_to_draw(user_id: user.id, qualities: [0, 1], hero_id: hero.id).length).to eq 3
      end
    end
  end

  describe '.i_to_quality' do
    it 'should convert integer to quality' do
      expect(Card.random_to_quality(1)).to eq 5
      expect(Card.random_to_quality(2)).to eq 4
      expect(Card.random_to_quality(11)).to eq 3
      expect(Card.random_to_quality(50)).to eq [0, 1]
    end
  end

  describe '.clean_total' do
    it 'should return expected clean total' do
      expect(Card.clean_total(0)).to raise_error
      expect(Card.clean_total(1)).to raise_error
      expect(Card.clean_total(2)).to eq 1
      expect(Card.clean_total(3)).to eq 1
      expect(Card.clean_total(4)).to eq 2
    end
  end
end
