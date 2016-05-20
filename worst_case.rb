require 'nokogiri'
require 'open-uri'
require "arduino_firmata"

#READ FROM ARDUINO PROGRAM
#INSTALL THIS TO THE BOARD: https://github.com/HashNuke/arduino/raw/master/arduino.pde
# board = Arduino.new("/dev/ttyUSB1")

# #SET OUTPUT PINS
# board.output(10,11,13)

# #DIGITAL IO - BASIC BLINKING FUNCTION
# #SET IN LOOP IF NEEDED
# Arduino.setHigh(13)
# sleep(1)
# Arduino.setLow(13)
# sleep(1)

# #ANALOG IO (PIN, VALUE)
# Arduino.analogRead(13, 255)
# Arduino.analogRead(13, 0)


#WORST CASE SCENARIO
#HOOK UP RED LED TO PIN 11
#HOOK UP GREEN LED TO PIN 10
#SURROUND WITH PAPER SO PAPER LIGHTS UP
#ENTER ZIP CODE, GREEN MEANS YOU ARE GOOD, RED MEANS GET A JACKET

print "Loading Arduino..."
#board = Arduino.new("/dev/cu.usbmodem1421")
arduino = ArduinoFirmata.connect "/dev/cu.usbmodem1421"
puts "firmata version #{arduino.version}"
arduino.pin_mode 10, ArduinoFirmata::OUTPUT
#connection :arduino, adaptor: :firmata, port: '/dev/cu.usbmodem1421'
#device :green_led, driver: :led, pin: 11
#device :red_led, driver: :led, pin: 10

#board = Dino::Board.new(Dino::TxRx.new)
#red_led = Dino::Components::Led.new(pin: 10, board: board)
#green_led = Dino::Components::Led.new(pin: 11, board: board)
#board.output(10,11)
print "Enter a zip code: "
zip = gets.chomp
doc = Nokogiri::HTML(open("https://doineedajacket.com/weather/#{zip}"))
jacket = doc.css("h1").text
puts jacket
jacket = "Yes"
if jacket == "Yes"
  puts "Turning pin 10 off"
  #board.setLow(10)
  puts "Turning pin 11 on"
  10.times do
      arduino.digital_write 10, true
      sleep(1)
      arduino.digital_write 10, false
  end
else
  puts "Turning pin 11 off"
  puts "Turning pin 10 on"
  10.times do
    sleep(1)
    sleep(1)
  end
end
sleep(10)
puts "Turning all off"
arduino.close