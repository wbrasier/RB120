# write a circular queue program
# nouns: queue size
# verbs: enqueue, dequeue

# set size of queue in initilization, all spots should be nil
#   set an array of that size

# When dequeue an item
#   find the oldest item
#   delete it from array and return the value
#   replace the value with nil

# When enqueue an item
#   check to see if that position is full
#     if it is full, replace oldest element
#   if it is not full, add to the lowest position in queue

class CircularQueue
  attr_reader :size
  attr_accessor :arr, :front_of_queue, :back_of_queue

  def initialize(size)
    @size = size
    @arr = Array.new(size)
    @front_of_queue = 0
    @back_of_queue = 0
  end

  def update_front_of_queue
    if front_of_queue == size - 1
      self.front_of_queue = 0
    else
      self.front_of_queue += 1
    end
  end

  def update_back_of_queue
    if back_of_queue == size - 1
      self.back_of_queue = 0
    else
      self.back_of_queue += 1
    end
  end

  def enqueue(item)
    old_item = arr[front_of_queue]
    arr[front_of_queue] = item
    update_front_of_queue
    update_back_of_queue if old_item != nil
  end

  def dequeue
    to_be_removed = arr[back_of_queue]
    arr[back_of_queue] = nil
    update_back_of_queue unless arr.all? { |element| element == nil }
    return to_be_removed
  end
end



queue = CircularQueue.new(3)
puts queue.dequeue == nil #true

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1 #false

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 5


puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil

queue = CircularQueue.new(4)
puts queue.dequeue == nil

queue.enqueue(1)
queue.enqueue(2)
puts queue.dequeue == 1

queue.enqueue(3)
queue.enqueue(4)
puts queue.dequeue == 2

queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
puts queue.dequeue == 4
puts queue.dequeue == 5
puts queue.dequeue == 6
puts queue.dequeue == 7
puts queue.dequeue == nil
