class Game
  attr_accessor :user_points
  attr_reader :deck, :user, :dealer, :user_points

  def initialize
    @dealer = []
    @user = []
    @bank = 0
    @deck ||= []
  end

  def creating_deck
    ["\u2660","\u2665","\u2663","\u2666"].each do |suit|
      [2,3,4,5,6,7,8,9,10,'V','Q','K','A'].each do |value|
        @deck << value.to_s + suit.to_s
      end
    end
  end

  def shuffling
    3.times do
      (0..5).each do |i|
        print "Shuffling" + "."*i, "\r"
        sleep 0.2
      end
      print "               ","\r"
    end
    deck.shuffle!
  end

  def deal_the_cards
    2.times do
      card = deck[0]
      user << card
      deck.delete card
      card = deck[0]
      dealer << card
      deck.delete card
    end
  end

  def user_points
    user.inject(0) do |sum, card|
      value = card[0].to_f unless card[0].to_f.zero?
      value = 10 if card[0].to_f.zero?
      sum + value
    end
  end

  def dealer_points
    dealer.inject(0) do |sum, card|
      value = card[0].to_f unless card[0].to_f.zero?
      value = 10 if card[0].to_f.zero?
      sum + value
    end
  end

end

@game = Game.new
@game.making_deck
@game.shuffling
@game.deal_the_cards
@game.user
@game.user_points
