
function love.load()
  firstTime = love.timer.getTime( )--os.clock()
  first = 0
  myFile = io.open("notesData3.txt","a")
  
end

function love.keypressed(key)
  local time
  time = tostring(love.timer.getTime( ) - firstTime)--os.clock())-- - firstTime)
  --firstTime = os.clock()
  local button
  
  if key == 'a' then
    button = "1"
  end
  if key == 's' then
    button = "2"
  end
  if key == 'd' then
    button = "3"
  end
  
  if key == 'return'then
    myFile:close()
    return
  end
  
 
  myFile:write(time.." "..button.."\n")
end


function love.update (dt)

end

function love.draw ()

end
