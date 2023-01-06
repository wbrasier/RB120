require 'pry'
require 'yaml'

class Participant
  attr_accessor :hand, :total, :stay_status, :wins

  def initialize(wins = 0)
    @hand = []
    @total = 0
    @stay_status = false
    @wins = wins
  end

  def update_total
    points = 0
    hand.each do |arr|
      arr.each { |_, worth| points += worth }
    end

    hand.select { |arr| arr.keys.join.include?('Ace') }.count.times do
      points -= 10 if points > TwentyOne::GAME_NUMBER
    end

    self.total = points
    points
  end

  def display_cards(crds, card_owner, amount_displayed)
    card_keys = crds.map(&:keys).flatten
    string = "#{card_owner} has: "
    case amount_displayed
    when 1    then string << "#{card_keys[0]} and mystery card"
    when 2    then string << "#{card_keys[0]} and #{card_keys[1]}"
    else
      string << card_keys[0...-1].join(', ')
      string << ", and #{card_keys[-1]}"
    end
    puts string
  end

  def hit(card)
    add_to_hand(card)
  end

  def bust?
    total > TwentyOne::GAME_NUMBER
  end

  def add_to_hand(card)
    hand << card
  end
end

class Player < Participant
  attr_accessor :name

  def initialize(name = '', wins = 0)
    @name = name
    super(wins)
  end

  def set_name
    answer = ''
    loop do
      puts "What is your name?"
      answer = gets.chomp
      break unless answer.empty?
      puts "Sorry invalid input, please enter your name."
    end
    self.name = answer
  end

  def display_cards_and_totals(round)
    puts "----------------------------------------"
    display_cards(hand, name, round)
    puts "Your total is #{update_total}"
    sleep 2
  end

  def bust
    puts "You busted!"
    sleep 1
  end

  def hit(card)
    puts "You decided to hit!"
    sleep 1
    super
  end

  def hit_or_stay
    answer = ''
    loop do
      puts "Would you like to hit or stay? (h/s)"
      answer = gets.chomp.downcase
      break if %(h s).include?(answer)
      puts "Invalid answer, please insert h or s"
    end
    self.stay_status = true if answer == 's'
    answer
  end

  def stay
    puts "You decided to stay!"
    sleep 2
  end
end

class Dealer < Participant
  attr_reader :name

  def initialize(wins = 0)
    @name = 'Jeff the Dealer'
    super(wins)
  end

  def display_cards_and_totals(round)
    display_cards(hand, name, round - 1)
    puts "Dealer total is #{update_total}"
    sleep 2
    puts "----------------------------------------"
  end

  def bust
    sleep 3
    puts "#{name} busted!"
  end

  def hit(card)
    sleep 2
    puts "Dealer hits!"
    super
  end

  def stay
    sleep 2
    puts "Dealer stays!"
  end
end

class Deck
  SUITS = ['Hearts', 'Spades', 'Clubs', 'Diamonds']
  FACES = ["Ace", "2", "3", "4", "5", "6", "7", "8",
           "9", "10", 'Jack', 'Queen', 'King']

  attr_accessor :deck

  def initialize
    @deck = make_deck_with_values
  end

  def make_deck_with_values
    cards = make_deck
    add_values(cards)
  end

  def make_deck
    cards = []

    SUITS.each do |suit|
      FACES.each do |face|
        cards << "#{face} of #{suit}"
      end
    end
    cards
  end

  def add_values(cards)
    cards.map! do |card|
      case card[0..1]
      when 'Ac'     then { card => 11 }
      when 'Ja'     then { card => 10 }
      when 'Qu'     then { card => 10 }
      when 'Ki'     then { card => 10 }
      when '10'     then { card => 10 }
      else               { card => card[0].to_i }
      end
    end
  end

  def deal_one
    deck.shuffle!
    deck.pop
  end
end

class TwentyOne
  GAME_NUMBER = 21
  DEALER_HITS_UNTIL = 17

  attr_reader :human, :computer
  attr_accessor :deck, :round
  @@game_number = 0

  def initialize
    display_start_up unless @@game_number > 1
    @deck = Deck.new
    @human = Player.new
    @computer = Dealer.new
    @round = 2
    @@game_number += 1
  end

  def start
    initial_game
    loop do
      system 'clear'
      human.display_cards_and_totals(round)
      computer.display_cards(computer.hand, computer.name, 1)
      loop do
        player_turn
        break if human.bust? || human.stay_status
      end
      dealer_turn unless human.bust?
      end_game
      break unless play_again?
      reset_game
    end
  end

  def initial_game
    display_welcome_message
    game_instructions if see_instructions?
    deal_initial_cards
  end

  def end_game
    display_both_cards
    display_winner
    display_ultimate_winner if ultimate_winner?
    display_scores
  end
  
  def reset_game
    @deck = Deck.new
    @human = Player.new(human.name, human.wins)
    @computer = Dealer.new(computer.wins)
    @round = 2
    @@game_number += 1
    deal_initial_cards
  end

  def display_start_up
    system 'clear'
    puts "The Game of Twenty One"
  end

  def display_welcome_message
    puts ""
    puts "Hello #{human.set_name}! Welcome to Twenty One!"
  end

  def see_instructions?
    answer = ''
    loop do
      puts "Would you like to read the instructions? (y/n)"
      answer = gets.chomp
      break if %(y n).include?(answer)
      puts "Sorry invalid answer, input y or n."
    end
    answer == 'y'
  end

  def game_instructions
    message = YAML.safe_load(File.read("twenty_one_instructions.yml"))
    message.each do |line|
      puts line
      gets.chomp
    end
    puts "---------------------------------"
    puts "Press Enter when you are ready to play!"
    answer = gets.chomp
    system 'clear' if answer
  end

  def deal_initial_cards
    2.times do
      human.add_to_hand(deck.deal_one)
      computer.add_to_hand(deck.deal_one)
    end
  end

  def display_both_cards
    human.display_cards_and_totals(round)
    computer.display_cards_and_totals(round)
  end

  def player_turn
    loop do
      self.round += 1
      if human.hit_or_stay == 'h'
        human.hit(deck.deal_one)
        human.display_cards_and_totals(round)
        if human.bust?
          human.bust
          break
        end
      else
        human.stay
        break
      end
    end
  end

  def dealer_turn
    system 'clear'
    puts "Time for the dealer to hit or stay!"
    loop do
      self.round += 1
      if computer.total < DEALER_HITS_UNTIL
        computer.hit(deck.deal_one)
        computer.update_total
        if computer.bust?
          computer.bust
          break
        end
      else
        computer.stay
        break
      end
    end
  end

  def display_winner
    winner = find_winner
    sleep 2
    if winner == 'human'
      puts "Congratulations! You won!"
    elsif winner == 'dealer'
      puts "#{computer.name} won. You lost."
    elsif winner == 'tie'
      puts "It's a tie!"
    end
  end

  def ultimate_winner?
    human.wins >= 5 || computer.wins >= 5
  end

  def display_ultimate_winner
    if human.wins >= 5
      puts "You, #{human.name}, are the ultimate winner!"
    else
      puts "#{computer.name} is the ultimate winner!"
    end
  end

  def find_winner
    if computer.bust?
      human.wins += 1
      'human'
    elsif human.bust? || computer.total > human.total
      computer.wins += 1
      'dealer'
    elsif human.total > computer.total
      human.wins += 1
      'human'
    else
      'tie'
    end
  end

  def play_again?
    answer = ''
    loop do
      puts "Would you like to play again? (y / n)"
      answer = gets.chomp.downcase
      break if %(y n).include?(answer)
      puts "Sorry, invalid input. Please enter y or n"
    end
    answer == 'y'
  end

  def display_scores
    puts "You have won #{human.wins} times."
    puts "#{computer.name} has won #{computer.wins} times."
  end
end

game = TwentyOne.new
game.start
