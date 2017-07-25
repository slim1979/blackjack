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
end
