require 'nokogiri'
require 'open-uri'
require 'arduino'

print "Loading Arduino..."
board = Arduino.new("/dev/cu.usbmodem1421")
#declare output pins
board.output(13, 11)
#perform operations

print "Enter a zip code: "
zip = gets.chomp
doc = Nokogiri::HTML(open("https://doineedajacket.com/weather/#{zip}"))
jacket = doc.css("h1").text
puts jacket
if jacket == "Yes"
    board.setLow(11)
    board.setHigh(13)
else 
    board.setLow(13)
    board.setHigh(11)
end
sleep(10)
board.turnOff
