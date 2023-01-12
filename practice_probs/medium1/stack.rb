# n Place a value n in the "register". Do not modify the stack.
# PUSH Push the register value on to the stack. Leave the value in the register.
# ADD Pops a value from the stack and adds it to the register value, storing the result in the register.
# SUB Pops a value from the stack and subtracts it from the register value, storing the result in the register.
# MULT Pops a value from the stack and multiplies it by the register value, storing the result in the register.
# DIV Pops a value from the stack and divides it into the register value, storing the integer result in the register.
# MOD Pops a value from the stack and divides it into the register value, storing the integer remainder of the division in the register.
# POP Remove the topmost item from the stack and place in register
# PRINT Print the register value

#input will be a string
#   if there is not a string, or it is unexpected produce an error

require 'pry'
class Minilang
  OPERATIONS = ['PRINT', 'PUSH', 'MULT', 'ADD', 'SUB', 'DIV', 'MOD', 'POP']
  attr_reader :operations
  attr_accessor :register, :stack

  def initialize(input)
    @operations = input.split(' ')
    @register = Register.new
    @stack = Stack.new
  end
  
  def eval
    operations.each do |op|
      valid?(op)
      case op
      when 'PRINT'  then prints
      when 'PUSH'   then push
      when 'MULT'   then mult
      when 'ADD'    then add
      when 'SUB'    then subtract
      when 'DIV'    then div
      when 'MOD'    then mod
      when 'POP'    then pop
      end
      register.update_register(op.to_i) if op.to_i.to_s == op
    end
  end
  
  def valid?(input)
    if !OPERATIONS.include?(input) && !number?(input)
      raise TypeError.new ("Invalid token :#{input}")
    end
  end
  
  def number?(input)
    if input =~ /\A[-+]?\d+\z/
      true
    else
      false
    end
  end
  
  def prints
    puts register.current_value
  end
  
  def push # adds register value to the stack
    stack << register.current_value
  end
  
  def mult # pops value from stack, and the sum of the value and register is new register
    register.update_register(register.current_value * stack.pop)
  end
  
  def add
    register.update_register(register.current_value + stack.pop)
  end
  
  def subtract
    register.update_register(register.current_value - stack.pop)
  end
  
  def div
    register.update_register(register.current_value / stack.pop)
  end
  
  def mod
    register.update_register(register.current_value % stack.pop)
  end
  
  def pop
    register.update_register(stack.pop)
  end
end

class Register
  attr_accessor :current_value
  
  def initialize
    @current_value = 0
  end
  
  def update_register(int)
    self.current_value = int
  end
end

class Stack
  attr_accessor :array
  
  def initialize
    @array = []
  end
  
  def <<(item)
    array.push(item)
  end
  
  def pop
    array.pop
  end
end


Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)