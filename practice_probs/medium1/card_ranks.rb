
require 'pry'
class Card
  include Comparable
  RANKING = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace']
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
  
  def to_s
    "#{rank} of #{suit}"
  end
  
  def min
    cards.sort[0]
  end
  
  def max
    cards.sort[-1]
  end
  
  def <=>(other)
    RANKING.index(rank) <=> RANKING.index(other.rank)
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  attr_accessor :deck
  
  def initialize
    @deck = make_deck.shuffle
  end
  
  def make_deck
    full_deck = []
    RANKS.each do |rank|
      SUITS.each do |suit|
        full_deck << Card.new(rank, suit)
      end
    end
    full_deck
  end
  
  def draw
    initialize if deck.size == 0
    self.deck.pop
  end
end

class PokerHand
  attr_accessor :poker_deck
  attr_reader :hand
  
  def initialize(deck)
    @poker_deck = deck
    @hand = draw_hand
  end

  def print
    hand.each do |card|
      puts card.to_s
    end
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private
  
  def draw_hand
    arr = []
    5.times do |_|
      arr << poker_deck.draw
    end
    arr
  end

  def royal_flush?
    return false unless hand.map(&:suit).uniq.size == 1
    sorted = hand.sort.map(&:rank)
    return false if sorted[0] != 10
    straight?
  end

  def straight_flush?
    return false unless hand.map(&:suit).uniq.size == 1
    straight?
  end

  def four_of_a_kind?
    multiples = {}
    hand.map(&:rank).each do |card|
      multiples[card] = hand.map(&:rank).count(card)
    end
    multiples.values.include?(4)
  end

  def full_house?
    multiples = {}
    hand.map(&:rank).each do |card|
      multiples[card] = hand.map(&:rank).count(card)
    end
    multiples.values.include?(3) && multiples.values.include?(2)
  end

  def flush?
    hand.map(&:suit).uniq.count == 1
  end

  def straight?
    sorted = hand.sort.map(&:rank)
    rank_index = Card::RANKING.index(sorted[0])
    hand_index = 0
    loop do
      return false unless sorted[hand_index] == Card::RANKING[rank_index]
      rank_index += 1
      hand_index += 1
      break if hand_index >= 4
    end
    true
  end

  def three_of_a_kind?
    multiples = {}
    hand.map(&:rank).each do |card|
      multiples[card] = hand.map(&:rank).count(card)
    end
    multiples.values.include?(3)
  end

  def two_pair?
    multiples = {}
    hand.map(&:rank).each do |card|
      multiples[card] = hand.map(&:rank).count(card)
    end
    multiples.values.count(2) == 2
  end

  def pair?
    hand.map(&:rank).uniq.size == 4
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'