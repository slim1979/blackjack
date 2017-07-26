class Game
  attr_accessor :dealer_response, :user_balance, :dealer_balance
  attr_reader :deck, :user_cards, :dealer_cards, :bank

  def initialize
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

  def bets
    bet = 10
    if @user_balance - bet >= 0
      @user_balance -= bet
      @bank += bet
      puts user_balance.to_s
    end
    if @dealer_balance - bet >= 0
      @dealer_balance -= bet
      @bank += bet
      puts dealer_balance.to_s
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

  def dealer_info(visibility)
    dealer_info = { 'hidden' => '// dealer >> ** points [ ' + '\'***\' ' * dealer_cards.length + ']',
                    'showed' => "// dealer >> #{dealer_points} points #{dealer_cards.keys}" }
    dealer_info[visibility]
  end

  def game_info(visibility)
    user_info = "#{user_cards.keys} #{user_points} points << user \\\\"
    puts user_info + ' VS ' + dealer_info(visibility)
    puts "Ваш баланс: #{user_balance}. В банке: #{bank}. Баланс казино #{dealer_balance}"
  end

  def user_move
    system('clear')
    puts 'User move'
    game_info 'hidden'
    print '1.Еще. 2.Пас. 3.Вскрыть карты :'
    choise gets.to_i
  end

  def dealer_move
    system('clear')
    puts 'Dealer move'
    game_info 'hidden'
    analyze
    @dealer_response += 1
    more_to_dealer if dealer_points / 0.21 < 80
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

  def user_win
    puts 'User win!'
    @user_balance += @bank
    @bank = 0
    game_info 'showed'
  end

  def dealer_win
    puts 'Dealer win!'
    @dealer_balance += @bank
    @bank = 0
    game_info 'showed'
  end

  def draw
    dealer_win if dealer_points == user_points
  end

  def on_first_move
    if user_win_with_distribution_or_dealer_overkill
      user_win
      once_more
    elsif dealer_win_with_distribution_or_user_overkill
      dealer_win
      once_more
    end
  end

  def on_second_move
    if user_points > dealer_points && user_points <= 21
      user_win
      once_more
    elsif dealer_points > user_points && dealer_points <= 21
      dealer_win
      once_more
    else
      draw
    end
  end

  def check_points
    system('clear')
    ace_behavior
    on_first_move if dealer_response.zero?
    on_second_move unless dealer_response.zero?
  end

  def game_process
    check_points
    user_move if user_cards.length < 3
    game_info 'hidden'
    check_points
    dealer_move if user_cards.length >= 3
    check_points
  end

  def choise(action)
    do_this = { 1 => -> { more_to_user },
                2 => -> { dealer_move },
                3 => -> { game_info 'showed' } }
    do_this[action].call
  end

  def more_to_user
    card_to 'user'
  end

  def more_to_dealer
    card_to 'dealer'
  end

  def once_more
    print 'Wanna play again? y/n :'
    answer = gets.strip.chomp.downcase
    new_game if %w[y l н д].include? answer
    goodbye unless %w[y l н д].include? answer
  end

  def new_game
    system('clear')
    user_cards.clear
    dealer_cards.clear
    @bank = 0
    @dealer_response = 0
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
