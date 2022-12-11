class MyCar
	attr_accessor :color
	attr_reader :year
	
	def initialize(year, color, model)
		@year = year
		@color = color
		@model = model
		@speed = 0
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
	
	def to_s
		"Your car is a #{color} #{@model} from #{year}."
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