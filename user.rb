class User
  attr_accessor :balance
  attr_reader :name, :cards

  def initialize(name)
    @name = name
    @balance = 100
    @cards = {}
  end

  def points
    cards.values.inject { |sum, value| sum + value }
  end

  def info
    "#{cards.keys} #{points} points << user \\\\"
  end

  def bet(bet)
    self.balance -= bet if balance - bet >= 0
  end

  def more
    card_to self.class.to_s.downcase
  end

  def overkill?
    points > 21
  end

  def got_21?
    points == 21
  end

  def in_range?
    points <= 21
  end

  def ad?(dealer)
    points > dealer.points
  end
end
