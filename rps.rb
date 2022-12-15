module AddMoveToHistory
  def add_move
    self.previous_moves << self.move.to_s
  end
end

class RPSGame
  ULTIMATE_SCORE = 10
  attr_accessor :human, :computer

  def initialize
    @human = Human.new(:human)
    @computer = Computer.new(:computer)
    @@human_score = 0
    @@computer_score = 0
  end

  def play
    display_wecome_message

    loop do
      human.choose
      computer.choose
      human.add_move
      computer.add_move
      display_moves
      display_winner
      ultimate_winner
      display_goodbye_message
      display_stats if stats?
      break unless play_again?
    end
  end

  def display_wecome_message
    puts "Welcome to Rock, Paper, Scissors!"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      @@human_score += 1
      puts "#{human.name} won and now has #{@@human_score} points!"
    elsif human.move < computer.move
      @@computer_score += 1
      puts "#{computer.name} won and now has #{@@computer_score} points!"
    else
      puts "It's a tie!"
    end
  end

  def ultimate_winner
    if @@human_score == ULTIMATE_SCORE
      puts "#{human.name} has reached #{ULTIMATE_SCORE} points
         and is the ultimate winner!"
    elsif @@computer_score == ULTIMATE_SCORE
      puts "#{computer.name} has reached #{ULTIMATE_SCORE} points
         and is the ultimate winner!"
    end
  end
  
  def stats?
    answer = nil
    loop do
      puts "Would you like to see the game stats? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end
    
    answer == 'y'
  end
  
  def display_stats 
    human_previous_moves = human.previous_moves
    puts "You played #{human_previous_moves} games."
    Move::VALUES.each do |move|
      count = human_previous_moves.count(move)
      puts "You played #{move} #{count} times." if count >= 1
    end
    puts "You won #{@@human_score} times."
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end
end

class Player
  include AddMoveToHistory
  attr_accessor :move, :name, :previous_moves

  def initialize(player_type = :human)
    @player_type = player_type
    @move = nil
    @previous_moves = []
    set_name
  end

  def human?
    @player_type == :human
  end
end

class Human < Player

  def set_name
    n = ''
    loop do
      puts "What is your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value. "
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Please choose rock, paper, lizard, spock, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player

  def set_name
    self.name = ['R2D2', 'Siri', 'Hal'].sample
  end
  
  def R2d2?
    name == 'R2D2'
  end
  
  def Siri?
    name == 'Siri'
  end
  
  def Hal?
    name == 'Hal'
  end

  def choose
    case name 
    when R2d2?
      self.move = R2d2.new(R2d2::MOVES.sample)
    when Siri?
      self.move = Siri.new(Siri::MOVES.sample)
    when Hal?
    end
    self.move = Move.new(Move::VALUES.sample)
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'spock', 'lizard']
  WINNING_MOVES = { 'rock' => ['lizard', 'scissors'],
                    'paper' => ['rock', 'spock'],
                    'scissors' => ['paper', 'lizard'],
                    'lizard' => ['spock', 'paper'],
                    'spock' => ['scissors', 'rock'] }
  LOSING_MOVES = { 'rock' => ['paper', 'spock'],
                   'paper' => ['lizard', 'scissors'],
                   'scissors' => ['rock', 'spock'],
                   'lizard' => ['scissors', 'rock'],
                   'spock' => ['lizard', 'paper'] }

  def initialize(value)
    @value = value
  end

  def >(other_move)
    WINNING_MOVES[@value].include?(other_move.to_s)
  end

  def <(other_move)
    LOSING_MOVES[@value].include?(other_move.to_s)
  end

  def to_s
    @value
  end
end

class R2d2 < Move
  MOVES = ['rock']
end

class Siri < Move
  MOVES = ['rock', 'rock', 'paper', 'paper', 'paper', 'scissors', 'scissors',
          'scissors', 'scissors', 'scissors', 'scissors', 'scissors',
          'lizard', 'lizard', 'lizard']
end


RPSGame.new.play
