# write a class that implements a fixed length array, and provides the necessary methods for the code below
# fixed length array = array with a set number of elements

# nouns: length, array, indexerror
# verbs: index return, convert to to array, setter method, 

# initial elements hsould all be nil

class FixedArray
  attr_reader :size, :array
  
  def initialize(size)
    @size = size
    @array = Array.new(size)
  end
  
  def [](index)
    array.fetch(index)
  end
  
  def []=(index, element)
    array.fetch(index)
    array[index] = element
  end
  
  def to_a
    array.clone
  end
  
  def to_s
    "#{array}"
  end
  
  private
  attr_writer :array
end



fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end