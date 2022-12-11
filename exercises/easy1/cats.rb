class Pet
  attr_reader :name, :age
  
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  attr_reader :coloring
  
  def initialize(name, age, coloring)
    super(name, age)
    @coloring = coloring
  end
  
  def to_s
    "My cat #{name} is #{age} years old and has #{coloring} fur."
  end
  
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch