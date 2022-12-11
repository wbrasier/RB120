class Person
  
  def initialize(first_name, last_name)
    @first_name = first_name.capitalize
    @last_name = last_name.capitalize
  end
  
  def first_name=(new_first)
    @first_name = new_first.capitalize
  end
  
  def last_name=(new_last)
    @last_name = new_last.capitalize
  end

  def to_s
    "#{@first_name} #{@last_name}"
  end
  # You could add .capitalize here but we shouldn't have the caller do that
end

person = Person.new('john', 'doe')
puts person

person.first_name = 'jane'
person.last_name = 'smith'
puts person