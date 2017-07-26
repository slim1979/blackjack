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

end
