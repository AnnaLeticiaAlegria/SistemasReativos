-- Renan da Fonte - 1412122
-- Pedro Ferreira - 1320981
-- Anna Letícia Alegria - 1410427

local mqtt = require("ext/mqtt_library")

--------------------------------------------------------------------------


--------------------------------------------------------------------------

function tabScene()
  return {
    draw = function ()
      love.graphics.setColor(255,255,255)
      if alertTab == true then
        tab = love.graphics.newImage( "img/alarmTab.png" )
      else
        tab = love.graphics.newImage( "img/requestTab.png")
      end
      love.graphics.draw(tab, 0, 0)
    end,
    getPositionAndSize = function ()
      return 0,0, 808,50
    end
    }
end

function alertScene ()
  local lat,long 
  local printLat = false
  return {
    draw = function ()
      love.graphics.setBackgroundColor(255,255,255)
      
      love.graphics.setColor(0,0,0)
      font = love.graphics.newFont(30)
      love.graphics.setFont(font)
      love.graphics.printf("do you want to receive alerts?", 0, screenHeight/6, screenWidth, 'center')
      love.graphics.setColor(255,255,255)
      if(alertsOn == true) then
        button = love.graphics.newImage( "img/yesButton.png" )
      else
        button = love.graphics.newImage( "img/noButton.png" )
      end
      love.graphics.draw(button, screenWidth/2 - 50 ,screenHeight/4)
    end,
    printLatandLong = function ()
      love.graphics.setColor(255,0,0)
      love.graphics.printf("alert received!!", 0, screenHeight/2.5, screenWidth, 'center')
      love.graphics.setColor(0,0,0)
      font = love.graphics.newFont(30)
      love.graphics.setFont(font)
      love.graphics.printf("latitude: "..lat, 0, screenHeight/2, screenWidth, 'center')
      love.graphics.printf("longitude: "..long, 0, screenHeight/1.7, screenWidth, 'center')
    end,
    setLatandLong = function (newLat, newLong)
      lat = newLat
      long = newLong
    end,
    getPositionAndSize = function ()
      return screenWidth/2 - 50,screenHeight/4, 100,50
    end
  }
end

function requestScene ()
  local lat, long
  local printLat = false
  
  return {
    draw = function ()
      love.graphics.setBackgroundColor(255,255,255)
      love.graphics.setColor(255,255,255)
      requestbutton = love.graphics.newImage( "img/requestButton.png" )
      love.graphics.draw(requestbutton, screenWidth/2 - 175.5 ,screenHeight/4)
    end,
    printLatandLong = function()
      love.graphics.setColor(0,0,0)
      font = love.graphics.newFont(30)
      love.graphics.setFont(font)
      love.graphics.printf("latitude: "..lat, 0, screenHeight/2, screenWidth, 'center')
      love.graphics.printf("longitude: "..long, 0, screenHeight/1.7, screenWidth, 'center')
    end,
    setLatandLong = function (newLat, newLong)
      lat = newLat
      long = newLong
    end,
    getPositionAndSize = function ()
      return screenWidth/2 - 175.5,screenHeight/4, 351,45
    end
  }
end

function alertReceived (message)
  if alertsOn == true then
    local pos1lat, pos2lat = string.find(message,'"lat": ')
    local posv = string.find(message, ",", pos2lat)
    
    local pos1long, pos2long = string.find(message,'"lng": ')
    local posc = string.find(message, "}", pos2long)
    local newLat = string.sub(message,pos2lat+1,posv-1)
    local newLong =  string.sub(message,pos2long+1,posc-2)
    alertreceived = true
    alertscene.setLatandLong(newLat, newLong)
    alertscene.printLat = true
  end
end

function requestLocation ()
  --mqtt pedir coordenadas
  
  requestscene.setLatandLong(-21.3333333,31.333333)

  requestscene.printLat = true
  
end

function mqttcb(topic, message)
   print("Received from topic: " .. topic .. " - message:" .. message)
   alertReceived(message)
   
end

function love.load()
  
  alertsOn = true
  alertTab = true
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  alertscene = alertScene()
  requestscene = requestScene()
  tabscene = tabScene()
  
  controle = false
  
  mqtt_client = mqtt.client.create("test.mosquitto.org", 1883, mqttcb)
  
  mqtt_client:connect("clientid 1320981")
  mqtt_client:subscribe({"inf1805-prl"})
  
end


function love.mousepressed(x, y, button, istouch)
     
    if button == 1 then
      local bX, bY, bW, bH = tabscene.getPositionAndSize()
      local b1X, b1Y, b1W, b1H = alertscene.getPositionAndSize()
      local b2X, b2Y, b2W, b2H = requestscene.getPositionAndSize()
      
      
      if alertTab == false and (x > bX and x < bX + bW/2) and (y > bY and y < bY + bH) then
        alertTab = true
      elseif alertTab == true and (x > bX + bW/2 and x < bX + bW) and (y > bY and y < bY + bH) then
        alertTab = false
      end
      
      if alertTab == true and (x > b1X and x < b1X + b1W) and (y > b1Y and y < b1Y + b1H) then
        alertsOn = not alertsOn
      elseif alertTab == false and (x > b2X and x < b2X + b2W) and (y > b2Y and y < b2Y + b2H) then
        requestLocation()
      end
    end
end

function love.keypressed (key)
  if key == "a" then
    --mqtt_client:publish("apertou-tecla", "a")
    --alertReceived()
  end
end


function love.update (dt)
  
  if alertsOn == false then
    alertscene.printLat = false
  end
  
  mqtt_client:handler()
  
end

function love.draw ()
  
   
  tabscene.draw()
  if alertTab == true then
    alertscene.draw()
    alertreceived = false
    
    if alertscene.printLat == true and alertsOn == true then
      alertscene.printLatandLong()
    end
    
  else
    requestscene.draw()
    if alertreceived == true then
      love.graphics.setColor(255,10,0)
      love.graphics.circle("fill",250,15, 7)
    end
    if requestscene.printLat == true then
      requestscene.printLatandLong()
    end
  end
  if controle then
     love.graphics.rectangle("line", 10, 10, 200, 150)
   end
end