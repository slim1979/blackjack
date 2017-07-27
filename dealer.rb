class Dealer < User
  attr_accessor :response

  def initialize(_name)
    super
    @response = 0
  end

  def analyze
    3.times do
      (0..5).each do |i|
        print 'Analyze' + '.' * i, "\r"
        sleep 0.2
      end
      print '               ', "\r"
    end
    self.response += 1
  end

  def info(visibility)
    info = { 'hidden' => '// dealer >> ** points [ ' + '\'***\' ' * cards.length + ']',
             'showed' => "// dealer >> #{points} points #{cards.keys}" }
    info[visibility]
  end

  def overkill?
    points > 21
  end

  def got_21?
    points == 21
  end

  def in_no_risk_zone?
    points / 0.21 < 80
  end

  def ad?(user)
    points > user.points
  end
end
