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
    bets
    deal_the_cards
    user_move
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

  def round_won_by(person)
    puts "#{person.name} win!"
    person.balance += bank
    self.bank = 0
    info 'showed'
    once_more
  end

  def draw?
    dealer.points == user.points
  end

  def dealer_wasnt_move_yet
    round_won_by user if user.got_21?
    round_won_by dealerif dealer.got_21? || user.overkill?
  end

  def user_win?
    user.ad?(dealer) && user.in_range?
  end

  def dealer_make_his_move
    round_won_by user if user_win? || dealer.overkill?
    round_won_by dealer unless user_win? || dealer.overkill?
  end

  def check_points
    system('clear')
    [user, dealer].each { |person| ace_behavior(person) }
    dealer_wasnt_move_yet if dealer.response.zero?
    dealer_make_his_move unless dealer.response.zero?
  end

  def won_by_points
    system('clear')
    round_won_by(user) if user.ad?(dealer)
    round_won_by(dealer) if dealer.ad?(user)
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
    card_to dealer if dealer.no_risk_zone?
    check_points
  end

  def choise(action)
    do_this = { 1 => -> { card_to user }, 2 => -> { dealer_move }, 3 => -> { won_by_points } }
    do_this[action].call
  end

  def once_more
    print 'Wanna play again? y/n :'
    answer = gets.strip.chomp.downcase
    new_game if %w[y l н д].include? answer
    puts 'Goodbye!'; exit unless %w[y l н д].include? answer
  end
end

@game = Game.new
