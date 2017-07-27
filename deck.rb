class Deck
  attr_accessor :content

  def initialize
    @content = []
    new
  end

  def new
    content.clear
    ["\u2660", "\u2665", "\u2663", "\u2666"].each do |suit|
      [2, 3, 4, 5, 6, 7, 8, 9, 10, 'V', 'Q', 'K', 'A'].each do |value|
        content << value.to_s + suit.to_s
      end
    end
    shuffle
  end

  def shuffle
    3.times do
      content.shuffle!
      (0..5).each do |i|
        print 'Shuffling' + '.' * i, "\r"
        sleep 0.2
      end
      print ' ' * 14, "\r"
    end
  end

  def value_of(card)
    value =  10 if card[0..-2].to_i.zero?
    value =  11 if card =~ /^A.$/
    value = card[0..-2].to_i unless card[0..-2].to_i.zero?
    value
  end
end
