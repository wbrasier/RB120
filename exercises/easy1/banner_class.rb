=begin
Create a banner around an input message and output it to the screen 
input: string
output: string with banner around it

print the top horizontal line
  create a string starting with '+-' then '-' the length of the string then '-+' 
print the spacing line
  create a string starting with '| ' then ' ' the length of the string then ' |' 
print the line with the message
  print a string '| ' then the message then ' |'
print the second spacing line
  same as previous one
print the bottom horizontal line
  same as previous one

=end

class Banner
  
  def initialize(message, length = (message.length))
    @message = message
    @length = length
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private
  attr_reader :length
  attr_reader :message

  def horizontal_rule
    '+-' + '-' * length + '-+'
  end

  def empty_line
    '| ' + ' ' * length + ' |'
  end

  def message_line
    "| "+ message.center(length) + " |"
  end
end

banner = Banner.new('To boldly go where no one has gone before.', 50)
puts banner