class Game
  attr_reader :deck, :user_cards, :dealer_cards, :bank, :balance

  def initialize
    @dealer_cards = {}
    @user_cards = {}
    @balance = 100
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

  def analyze
    3.times do
      (0..5).each do |i|
        print 'Analyze' + '.' * i, "\r"
        sleep 0.2
      end
      print '               ', "\r"
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

  def value(card)
    value =  10 if card[0..-2].to_i.zero?
    value =  11 if card =~ /^A.$/
    value = card[0..-2].to_i unless card[0..-2].to_i.zero?
    value
  end

  def card_to(person)
    card = deck.first
    send("#{person}_cards")[card] = value(card)
    deck.delete card
  end

  def deal_the_cards
    2.times do
      card_to 'user'
      card_to 'dealer'
    end
  end

  def ace_behavior
    if user_points > 21
      user_cards.keys.each do |card|
        user_cards[card] = 1 if card =~ /^A.$/
      end
    end
  end

  def user_points
    user_cards.values.inject { |sum, value| sum + value }
  end

  def dealer_points
    dealer_cards.values.inject { |sum, value| sum + value }
  end

  def game_info
    user_info = "#{user_cards.keys} #{user_points} points << user \\\\"
    dealer_hidden = '// dealer >> ** points [ ' + '\'***\' ' * dealer_cards.length + ']'
    puts user_info + ' VS ' + dealer_hidden
  end

  def user_move
    system('clear')
    puts 'User move'
    game_info
    puts "Ваш баланс: #{balance}. В банке: #{bank}."
    print '1.Еще. 2.Пас. 3.Вскрыть карты :'
    choise gets.to_i
  end

  def dealer_move
    system('clear')
    puts 'Dealer move'
    game_info
    analyze
    more_to_dealer if dealer_points / 0.21 < 80
    showdown unless dealer_points / 0.21 < 80
  end

  def user_win_with_distribution_or_dealer_overkill
    user_points == 21 || dealer_points > 21
  end

  def dealer_win_with_distribution_or_user_overkill
    dealer_points == 21 || user_points > 21
  end

  def user_and_dealer_own_3_cards
    user_cards.length == 3 && dealer_cards.length == 3
  end

  def check_points
    if user_win_with_distribution_or_dealer_overkill
      puts 'User win!'
      once_more
    elsif dealer_win_with_distribution_or_user_overkill
      puts 'Dealer win!'
      once_more
    elsif user_and_dealer_own_3_cards
      won_by_points
      once_more
    end
  end

  def won_by_points
    if user_points > dealer_points
      puts 'User win!'
    else
      puts 'Dealer win!'
    end
  end

  def game_process
    ace_behavior
    check_points
    user_move if user_cards.length < 3
    game_info
    check_points
    dealer_move if user_cards.length >= 3
    showdown
  end

  def choise action
    do_this = { 1 => -> { more_to_user },
                2 => -> { dealer_move },
                3 => -> { showdown } }
    do_this[action].call
  end

  def more_to_user
    card_to 'user'
  end

  def more_to_dealer
    card_to 'dealer'
  end

  def showdown
    system('clear')
    check_points
    user_info = "#{user_cards.keys} #{user_points} points << user \\\\"
    dealer_info = "// dealer >> #{dealer_points} points #{dealer_cards.keys}"
    puts user_info + ' VS ' + dealer_info
    check_points
  end

  def once_more
    puts 'Wanna play again?'
    answer = gets
    new_game if answer.include? %w[y д]
    goodbye unless answer.include? %w[y д]
  end
end

@game = Game.new
@game.new_deck
@game.shuffling
@game.deal_the_cards
# loop do
@game.game_process
# end
