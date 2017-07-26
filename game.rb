require_relative 'user.rb'
require_relative 'dealer.rb'

class Game
  attr_accessor :bank
  attr_reader :user, :dealer, :deck

  def initialize
    puts 'Enter your name:'
    @user = User.new(gets.strip.chomp)
    @dealer = Dealer.new('Tobby')
    @bank = 0
    @deck ||= []
    new_game
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

  def info(visibility)
    puts user.info + ' VS ' + dealer.info(visibility)
    puts "Ваш баланс: #{user.balance}. В банке: #{bank}. Баланс казино #{dealer.balance}"
  end

  def bets
    bet = 10
    self.bank += bet if user.bet(bet)
    self.bank += bet if dealer.bet(bet)
  end

  def value(card)
    value =  10 if card[0..-2].to_i.zero?
    value =  11 if card =~ /^A.$/
    value = card[0..-2].to_i unless card[0..-2].to_i.zero?
    value
  end

  def card_to(person)
    card = deck.first
    person.cards[card] = value(card)
    deck.delete card
  end

  def deal_the_cards
    2.times do
      card_to user
      card_to dealer
    end
  end

  def ace_behavior
    user.cards.keys.each { |card| user.cards[card] = 1 if card =~ /^A.$/ } if user.points > 21
    dealer.cards.keys.each { |card| dealer.cards[card] = 1 if card =~ /^A.$/ } if dealer.points > 21
  end

  def user_win
    puts "#{user.name} win!"
    user.balance += bank
    self.bank = 0
    info 'showed'
    once_more
  end

  def dealer_win
    puts "#{dealer.name} win!"
    dealer.balance += bank
    self.bank = 0
    info 'showed'
    once_more
  end

  def draw
    dealer_win if dealer.points == user.points
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
      user_win
    elsif dealer_win_with_distribution
      dealer_win
    end
  end

  def on_second_move
    if user.points > dealer.points && user.points <= 21 || dealer_overkill?
      user_win
    else
      dealer_win
    end
  end

  def check_points
    system('clear')
    ace_behavior
    on_first_move if dealer.response.zero?
    on_second_move unless dealer.response.zero?
  end

  def won_by_points
    system('clear')
    user_win if user.points > dealer.points
    dealer_win if dealer.points > user.points
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
                2 => -> { dealer.move },
                3 => -> { won_by_points } }
    do_this[action].call
  end

  def more_to_dealer
    card_to 'dealer'
  end

  def once_more
    print 'Wanna play again? y/n :'
    answer = gets.strip.chomp.downcase
    new_game if %w[y l н д].include? answer
    false unless %w[y l н д].include? answer
  end

  def new_game
    system('clear')
    user.cards.clear
    dealer.cards.clear
    self.bank = 0
    dealer.response = 0
    new_deck
    shuffling
    deal_the_cards
    bets
    game_process
  end

  def goodbye
    puts 'so long!'
  end
end

@game = Game.new
