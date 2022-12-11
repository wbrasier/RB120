class Vehicle
  attr_reader :make, :model
  
  def initialize(make, model)
    @make = make
    @model = model
  end
  
  def to_s
    "#{make} #{model}"
  end
  
  def wheels 
    self.class::WHEELS
  end
  
end

class Car < Vehicle
  WHEELS = 4
end

class Motorcycle < Vehicle
  WHEELS = 2
end

class Truck < Vehicle
  attr_reader :payload
  WHEELS = 6

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end
end