class Game
  attr_reader :deck, :user_cards, :dealer_cards

  def initialize
    @dealer_cards = {}
    @user_cards = {}
    @bank = 0
    @deck ||= []
  end

  def new_deck
    ["\u2660", "\u2665", "\u2663", "\u2666"].each do |suit|
      [2, 3, 4, 5, 6, 7, 8, 9, 10, 'V', 'Q', 'K', 'A'].each do |value|
        @deck << value.to_s + suit.to_s
      end
    end
  end

  def shuffling
    3.times do
      deck.shuffle!
      (0..5).each do |i|
        print 'Shuffling' + '.' * i, "\r"
        sleep 0.2
      end
      print '               ', "\r"
    end
  end

  def deal_the_cards
    2.times do
      card = deck.first
      value = 10 if card[0..-2].to_i.zero?
      value = 11 if card =~ /^A.$/
      value = card[0..-2].to_i unless card[0..-2].to_i.zero?
      user_cards[card] = value
      deck.delete card

      card = deck.first
      value = 10 if card[0..-2].to_i.zero?
      value = 11 if card =~ /^A.$/
      value = card[0..-2].to_i unless card[0..-2].to_i.zero?
      dealer_cards[card] = value
      deck.delete card
    end
  end

  def cards_behavior
    ace = /^A.$/
    if user_points > 21
      user_cards.keys.each do |card|
        user_cards[card] = 1 if card =~ ace
      end
    end
  end

  def user_points
    user_cards.values.inject(0) { |sum, value| sum + value }
  end

  def dealer_points
    dealer_cards.inject(0) do |sum, card|
      value = card[0..-2].to_i unless card[0..-2].to_i.zero?
      value = 10 if card[0..-2].to_i.zero?
      sum + value
    end
  end

  # def game_process
  #   puts "#{user_cards} #{user_points} points |< user VS dealer >| ** points ['***', '***']"
  # end

  def more_to_user
    card = deck.first
    value = 10 if card[0..-2].to_i.zero?
    value = 11 if card =~ /^A.$/
    value = card[0..-2].to_i unless card[0..-2].to_i.zero?
    user_cards[card] = value
    deck.delete card
  end
end

@game = Game.new
@game.new_deck
@game.shuffling
@game.deal_the_cards
# @game.user_cards
