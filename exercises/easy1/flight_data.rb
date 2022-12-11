class Flight

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# having an unnecessary accessor method will make it so that it can be altered