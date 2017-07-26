require_relative 'user.rb'
require_relative 'dealer.rb'
require_relative 'game.rb'

puts 'Enter your name:'
@user = User.new(gets.strip.chomp)
@dealer = Dealer.new('Tobby')
@game = Game.new
