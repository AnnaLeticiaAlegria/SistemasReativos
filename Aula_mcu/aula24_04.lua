ledR = 3
ledG = 6
but1 = 1
but2 = 2

gpio.mode(ledR, gpio.OUTPUT)
gpio.mode(ledG, gpio.OUTPUT)

gpio.mode(but1,gpio.INT,gpio.PULLUP)
gpio.mode(but2,gpio.INT,gpio.PULLUP)

gpio.write(ledR, gpio.LOW)
gpio.write(ledG, gpio.LOW)

blinkTime = 500
state = 1
firstTime = tmr.now()
lastButton = 0

local function piscar (t)
     state = not state
     if state then
	gpio.write(ledR,gpio.HIGH)
	gpio.write(ledG,gpio.LOW)
     else
 	gpio.write(ledR,gpio.LOW)
	gpio.write(ledG,gpio.HIGH)
     end	
end

local timer = tmr.create()
timer:register(blinkTime, tmr.ALARM_AUTO, piscar)
timer:start()

local function acccb (level, timestamp)

	if(lastButton ~= 2) then 
	  firstTime = tmr.now()
	  blinkTime = blinkTime - 100
	  timer:stop()
	  timer:register(blinkTime, tmr.ALARM_AUTO, piscar)
	  timer:start()
	else
	  if(tmr.now() - firstTime < 500) then
		timer:stop()
	  end
	end
end

local function deccb (level, timestamp)

	if(lastButton ~= 1) then 
	  firstTime = tmr.now()
	  blinkTime = blinkTime + 100
	  timer:stop()
	  timer:register(blinkTime, tmr.ALARM_AUTO, piscar)
	  timer:start()
	else
	  if(tmr.now() - firstTime < 500) then
		timer:stop()
	  end
	end
end

gpio.trig(but1, "down", acccb)
gpio.trig(but2, "down", deccb)
