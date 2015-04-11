class CardService
  def initialize(params = {})
    raise('Cards param must be set') if params[:cards].nil?
    @cards = params[:cards]
  end

  def random_ntuple(n)
    raise('n must be lower than @cards.length') if @cards.length < n
    get_random_ntuple(n)
  end

  def flatten(is_total_must_be_clean = false)
    flattened_cards = []
    @cards.each do |c|
      total = is_total_must_be_clean ? clean_total(c.total) : c.total
      total.times { flattened_cards.push(c) }
    end
    flattened_cards
  end

  def clean_total(i)
    raise('Unexpected total') unless i.between?(2, 4)
    i == 4 ? 2 : 1
  end

  private
    def get_random_ntuple(n)
      cards_buffer = @cards.clone
      n.times.map do
        cards_buffer.slice!(rand(0..cards_buffer.length - 1))
      end
    end
end