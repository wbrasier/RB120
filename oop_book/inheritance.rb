module Offroadable
  def offroad
    "Ready for the mud!"
  end
end

class Vehicle
  attr_accessor :color
	attr_reader :year
	
	@@number_of_cars = 0
	
	def initialize(year, color, model)
		@year = year
		@color = color
		@model = model
		@speed = 0
		@@number_of_cars += 1
	end
	
	def self.total_number_of_cars
	  @@number_of_cars
	end
	
	def info
		puts "Your #{color} #{@model} from #{year} is going #{@speed} mph."
	end

	def speed_up(number)
		@speed += number
		puts "You push the gas and now your current speed is #{@speed} mph."
	end 
	
	def brake(number)
		@speed -= number
		puts "You push the brakes and now your current speed is #{@speed} mph."
	end 
	
	def turn_off_car
		@speed = 0
		puts "Time to turn the car off!"
	end
	
	def spray_paint(new_color)
		self.color = new_color
	end
	
	def self.gas_mileage(gallons, miles)
		puts "#{miles / gallons} miles per gallon of gas."
	end
	
	def age
		puts "Your #{@model} is #{calculate_age} years old!"
	end
	
	private 
	
	def calculate_age
		Time.new.year - year
	end
	
end

class MyCar < Vehicle
	DOORS = 4
	
	def to_s
		"Your car is a #{color} #{@model} from #{year}."
	end
end

class MyTruck < Vehicle
  include Offroadable
  
  DOORS = 2
  
  def to_s
    "Your truck is a #{color} #{@model} from #{year}."
  end
end

main_car = MyCar.new(2020, "ice silver", "outback")
main_car.info
main_car.speed_up(18)
main_car.brake(7)
main_car.info
main_car.spray_paint('red')
main_car.info
main_car.turn_off_car
main_truck = MyTruck.new(2022, 'red', "tundra")
main_truck.info 
puts Vehicle.total_number_of_cars
puts main_truck.offroad
main_car.age
puts MyCar.ancestors
