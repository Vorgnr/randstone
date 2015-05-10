require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '.random_numplet' do
    context 'when users have enough cards' do
      it 'should return uniq cards nuplet' do
        cards = 5.times.map { create(:card) }
        expect(cards.uniq { |c| c.id }.length).to eq 5
        nuplet = Card.random_nuplet(5, cards)
        u = nuplet.uniq { |c| c.id }
        expect(u.length).to eq 5
      end
    end

    context 'when users have not enough cards' do
      context 'when cards is nil' do
        it 'should raise error ' do
          expect { Card.random_nuplet(5, nil) }.to raise_error
        end
      end
      context 'when cards is not nil' do
        it 'should return duplicate cards nuplet ' do
          cards = 2.times.map { create(:card) }
          expect(Card.random_nuplet(5, cards).length).to eq 5
        end
      end
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
      quality = Card.random_quality [5, 4, 3]
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
    context 'when all qualities are availables' do
      it 'should convert integer to quality' do
        availables_qualities = [5, 4, 3]
        expect(Card.random_to_quality(1, availables_qualities)).to eq 5
        expect(Card.random_to_quality(2, availables_qualities)).to eq 4
        expect(Card.random_to_quality(11, availables_qualities)).to eq 3
        expect(Card.random_to_quality(50, availables_qualities)).to eq [0, 1]
      end
    end

    context 'when all qualities are not availables' do
      context 'when legendary quality is not available' do
        it 'should convert integer to quality' do
          expect(Card.random_to_quality(1, [4, 3])).to eq 4
          expect(Card.random_to_quality(1, [3])).to eq 3
        end
      end

      context 'when epic quality is not available' do
        it 'should convert integer to quality' do
          expect(Card.random_to_quality(1, [5, 3])).to eq 5
          expect(Card.random_to_quality(2, [5, 3])).to eq 3
        end
      end

      context 'when rare quality is not available' do
        it 'should convert integer to quality' do
          expect(Card.random_to_quality(15, [5, 4])).to eq [0, 1]
        end
      end
    end
  end

  describe '.clean_total' do
    it 'should return expected clean total' do
      expect { Card.clean_total(0) }.to raise_error
      expect { Card.clean_total(1) }.to raise_error
      expect(Card.clean_total(2)).to eq 1
      expect(Card.clean_total(3)).to eq 1
      expect(Card.clean_total(4)).to eq 2
    end
  end

  describe '.flatten' do
    context 'when total has not to be cleaned' do
      it 'it flattened cards' do
        user = create(:user)
        cards = 5.times.map { create(:card) }
        user.cards << cards + cards
        cards = Card.cards_to_draw(user_id: user.id)
        flat_cards = Card.flatten(cards);
        expect(flat_cards.length).to eq 10
        expect(flat_cards.all? { |c| c.is_a? Card }).to be true
      end
    end
  end

  describe '.get_trio' do
    context 'when there is an opponent' do
      it 'should return trio of cards' do
        user = create(:user)
        userb = create(:user)
        base = 2.times.map { create(:card, :with_base_quality) }
        common = 2.times.map { create(:card, :with_common_quality) }
        epic = 4.times.map { create(:card, :with_epic_quality) }
        rare = 4.times.map { create(:card, :with_rare_quality) }
        legendary = 4.times.map { create(:card, :with_legendary_quality) }
        cards = base + common + rare + epic + legendary
        user.cards << cards + cards
        userb.cards << cards
        trio = Card.get_trio(user_id: user.id, opponent_id: userb.id)
        expect(trio.length).to eq 3
      end
    end

    context 'when there is no opponent' do
      it 'should return trio of cards' do
        user = create(:user)
        cards = 5.times.map { create(:card) }
        user.cards << cards
        trio = Card.get_trio(user_id: user.id)
        expect(trio.length).to eq 3
      end
    end

    context 'when current_deck already has cards' do
      it 'should remove those cards' do
        cards = 4.times.each_with_index.map { |x,i| create(:card, id: i + 1) }
        user = create(:user, :with_pick_cards_deck)
        deck = user.current_deck
        user.cards << cards + cards
        card_one = Card.find(1)
        deck.cards << [card_one]
        cards_to_draw = Card.cards_to_draw(user_id: user.id)
        expect(cards_to_draw.length).to eq 4
        flattened_cards = Card.flatten(cards_to_draw)
        expect(flattened_cards.length).to eq 8
        Card.remove_cards_already_in_deck(deck.cards, flattened_cards)
        expect(flattened_cards.length).to eq 7
      end
    end
  end

  describe 'all_with_collection_of' do
    it 'should return all card' do
      user = create(:user)
      cards = 5.times.map { create(:card) }
      expect(Card.all_with_collection_of(user.id).length).to eq 5
    end

    it 'should return a total column' do
      user = create(:user)
      cards = 5.times.map { create(:card) }
      expect(Card.all_with_collection_of(user.id).first.total).to eq 0
    end

    it 'should correctly count card in user\'s collection' do
      user = create(:user)
      cards = 5.times.map { create(:card) }
      user.cards << [cards[0], cards[0], cards[1]]
      all_card_and_user_collection = Card.all_with_collection_of(user.id)
      expect(all_card_and_user_collection.find(cards[0]).total).to eq 2
      expect(all_card_and_user_collection.find(cards[1]).total).to eq 1
    end
  end

  describe 'all_that_user_can_add' do
    context 'when not used with with_qualities filer' do
      context 'when user has one legendary card' do
        it 'should return all legendary except this one' do
          user = create(:user)
          cards = 5.times.map { create(:card, :with_legendary_quality) }
          user.cards << cards.first
          expect(Card.all_that_user_can_add(user.id).length).to eq 4
        end
      end
    end
    context 'when used with with_qualities filer' do
      context 'when user has one legendary card' do
        it 'should return all legendary except this one' do
          user = create(:user)
          cards = 5.times.map { create(:card, :with_legendary_quality) }
          user.cards << cards.first
          expect(Card.all_that_user_can_add(user.id).with_qualities(5).length).to eq 4
          expect(Card.all_that_user_can_add(user.id).with_qualities(2).length).to eq 0
        end
      end
    end
  end

  describe 'join_collection_of' do
    it 'should filter by cards of user' do
      user = create(:user)
      cards = 5.times.map { create(:card) }
      user.cards << [cards[0], cards[1]]
      expect(Card.join_collection_of(user.id).length).to eq 2
    end
  end

  describe 'filter_by_cost' do
    before(:each) do
      create(:card, cost: 2)
      create(:card, cost: 9)
      create(:card, cost: 7)
     end

    context 'when cost == All' do
      it 'should not filter' do
        expect(Card.filter_by_cost.length).to eq 3
      end
    end

    context 'when cost == 7' do
      it 'should return card with cost >= 7' do
        expect(Card.filter_by_cost(7).length).to eq 2
      end
    end

    context 'when cost < 7' do
      it 'should return card with cost < 7' do
        expect(Card.filter_by_cost(2).length).to eq 1
      end
    end
  end

  describe 'with_name' do
    before(:each) do
      2.times { create(:card, name: 'dummy') }
    end

    it 'should return which start with name' do
      create(:card, name: 'abcxxx')
      expect(Card.with_name('abc').length).to eq 1
    end

    it 'should return which contains name' do
      create(:card, name: 'xxxxabcxxx')
      expect(Card.with_name('abc').length).to eq 1
    end

    it 'should return which end with name' do
      create(:card, name: 'xxxxabc')
      expect(Card.with_name('abc').length).to eq 1
    end
  end

  describe 'filter_by_hero' do
    let(:hero_a) { create(:hero) }
    let(:hero_b) { create(:hero) }
    before(:each) do
      create(:card, hero: hero_a)
      create(:card)
      create(:card, hero: hero_b)
    end

    context 'when hero is empty' do
      it 'should return card without hero' do
        expect(Card.filter_by_hero('').length).to eq 1
      end
    end

    context 'when hero == All' do
      it 'should not filter by hero' do
        expect(Card.filter_by_hero('All').length).to eq 3
      end
    end

    context 'when hero is a correct hero id' do
      it 'should filter by hero id' do
        expect(Card.filter_by_hero(hero_a.id.to_s).length).to eq 1
      end
    end
  end
end


