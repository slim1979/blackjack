require_relative 'user.rb'
require_relative 'deck.rb'
require_relative 'dealer.rb'

class Game
  attr_accessor :bank
  attr_reader :user, :dealer, :deck

  def initialize
    puts 'Enter your name:'
    @user = User.new(gets.strip.chomp)
    @dealer = Dealer.new('Tobby')
    new_game
  end

  def new_game
    system('clear')
    user.cards.clear
    dealer.cards.clear
    dealer.response = 0
    @bank = 0
    @deck = Deck.new
    deal_the_cards
    bets
    game_process
  end

  def info(visibility)
    puts user.info + ' VS ' + dealer.info(visibility)
    puts "Ваш баланс: #{user.balance}. В банке: #{bank}. Баланс казино #{dealer.balance}"
  end

  def bets
    bet = 10
    self.bank += bet if user.bet(bet)
    self.bank += bet if dealer.bet(bet)
  end

  def card_to(person)
    card = deck.content.first
    person.cards[card] = deck.value_of(card)
    deck.content.delete card
  end

  def deal_the_cards
    2.times do
      card_to user
      card_to dealer
    end
  end

  def ace_behavior(person)
    person.cards.keys.each { |card| person.cards[card] = 1 if card =~ /^A.$/ } if person.points > 21
  end

  def persons
    [user, dealer]
  end

  def round_won_by(person)
    puts "#{person.name} win!"
    person.balance += bank
    self.bank = 0
    info 'showed'
    # once_more
  end

  def draw
    round_won_by dealer if dealer.points == user.points
  end

  def dealer_overkill?
    dealer.points > 21
  end

  def user_overkill?
    user.points > 21
  end

  def user_win_with_distribution
    user.points == 21 || dealer_overkill?
  end

  def dealer_win_with_distribution
    dealer.points == 21 || user_overkill?
  end

  def on_first_move
    if user_win_with_distribution
      round_won_by user
    elsif dealer_win_with_distribution
      round_won_by dealer
    end
  end

  def on_second_move
    if user.points > dealer.points && user.points <= 21 || dealer_overkill?
      round_won_by user
    else
      round_won_by dealer
    end
  end

  def check_points
    system('clear')
    persons.each { |person| ace_behavior(person) }
    on_first_move if dealer.response.zero?
    on_second_move unless dealer.response.zero?
  end

  def won_by_points
    system('clear')
    round_won_by(user) if user.points > dealer.points
    round_won_by(dealer) if dealer.points > user.points
  end

  def user_move
    system('clear')
    check_points
    puts "#{user.name} move"
    info 'hidden'
    print '1.Еще. 2.Пас. 3.Вскрыть карты :'
    choise gets.to_i
  end

  def dealer_move
    system('clear')
    check_points
    puts "#{dealer.name} move"
    info 'hidden'
    dealer.analyze
    card_to dealer if dealer.points / 0.21 < 80
    check_points
  end

  def game_process
    user_move
    dealer_move
  end

  def choise(action)
    do_this = { 1 => -> { card_to user },
                2 => -> { dealer_move },
                3 => -> { won_by_points } }
    do_this[action].call
  end

  def once_more
    print 'Wanna play again? y/n :'
    answer = gets.strip.chomp.downcase
    new_game if %w[y l н д].include? answer
    puts 'Goodbye!' && exit unless %w[y l н д].include? answer
  end
end

@game = Game.new
