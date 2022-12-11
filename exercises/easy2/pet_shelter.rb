class Pet
  @@number_of_pets_in_shelter = 0
  
  attr_reader :name, :animal
  
  def initialize(animal, name)
    @animal = animal
    @name = name
    @@number_of_pets_in_shelter += 1
  end
  
  def adopt
    @@number_of_pets_in_shelter -=1
  end
  
  def self.NumberOfPetsInShelter
    @@number_of_pets_in_shelter
  end
end

class Owner
  attr_reader :name
  attr_accessor :pets
  
  def initialize(name)
    @name = name
    @pets = []
  end
  
  def adopt(pet)
    pets << pet
    pet.adopt
  end
  
  def number_of_pets
    pets.size
  end
  
end

class Shelter
  attr_accessor :owners 
  
  def initialize
    @owners = []
  end
  
  def adopt(owner, pet)
    owner.adopt(pet)
    owners << owner if !owners.include?(owner)
  end
  
  def print_adoptions
    owners.each do |owner|
      puts "#{owner.name} has adopted the following pets:"
      owner.pets.each do |pet|
        puts "a #{pet.animal} named #{pet.name}"
      end
    end
  end
  
  def display_total_unadopted_pets
    puts "The animal shelter has #{Pet.NumberOfPetsInShelter} unadopted pets."
  end
end



butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')
little_john  = Pet.new('rabbit', 'Little John')
peppas       = Pet.new('fish', 'Peppas')
 
phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')
qmccoy  = Owner.new('Q McCoy')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)
shelter.adopt(qmccoy, little_john)
shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."
puts "#{qmccoy.name} has #{qmccoy.number_of_pets} adopted pets."
shelter.display_total_unadopted_pets