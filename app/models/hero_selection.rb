class HeroSelection < ActiveRecord::Base
    serialize :values
    belongs_to :deck

    def self.save_selection(deck_id, heroes)
        raise "Unexpected heroes count : must be 3, have #{heroes.length}" unless heroes.length == 3
        HeroSelection.create(deck_id: deck_id, values: heroes)
    end

    def self.destroy_by_deck_id(deck_id)
        selection = HeroSelection.find_by(deck_id: deck_id)
        selection.destroy
    end
end
