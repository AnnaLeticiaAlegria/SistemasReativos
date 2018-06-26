function createNote (noteTy, deltaTime)
  
  local w, h = 50, 50
  local posX, posY = 0, screenHeight/8.0
  local speed = deltaTime
  local noteType = noteTy
  local fileName
  
  if noteTy == 1 then
    fileName = "nota1.png"
    posX = screenWidth/4
  elseif noteTy == 2 then
    fileName = "nota2.png"
    posX = screenWidth/2
  else
    fileName = "nota3.png"
    posX = screenWidth*3/4
  end
  

  return {
    draw = function ()
      if isGameOver == false and isWinner == false then
        local musicButton = love.graphics.newImage( fileName )
        love.graphics.draw(musicButton, posX, posY, nil, w/500, h/500)
      end
    end,
    getSize = function ()
      return w,h
    end,
    update = function ()
      posY = posY + speed
    end,
    getPosition = function ()
      return posX, posY
    end
  } 
end

function createBases (baseTy)
  
  local w, h = 50, 50
  local posX, posY = 0, screenHeight* 7/8.0
  local baseType = baseTy
  local fileName
  
  if baseTy == 1 then
    fileName = "base1.png"
    posX = screenWidth/4
  elseif baseTy == 2 then
    fileName = "base2.png"
    posX = screenWidth/2
  else
    fileName = "base3.png"
    posX = screenWidth*3/4
  end
  

  return {
    draw = function ()
      local baseButton = love.graphics.newImage( fileName )
      love.graphics.draw(baseButton, posX, posY, nil, w/500, h/500)

    end,
    getSize = function ()
      return w,h
    end,
    
    getPosition = function ()
      return posX, posY
    end
  }
end

function placeElements ()
  
  baseList = {}
  
  for i = 1, 3 do
    baseList[i] = createBases(i)
  end
  
  noteslist = {}
  
  for i = 1,10 do
    noteslist[i] = createNote(math.random(1,3), math.random(20))
  end

end

function collision (xA,yA,wA,hA,xB,yB,wB,hB)

--print("Entrei na colision")
--print("xA: ".. xA .." yA: ".. yA .. " wA: " .. wA .. " hA: " ..hA);
--print("xB: "..xB .." yB: ".. yB .. " wB: " .. wB .. " hB: ".. hB);
  if ((xA < (xB + wB) and xA > xB) or
        ((xA + wA) > xB and (xA + wA) < (xB + wB))) and
       ((yA < (yB + hB) and yA > yB) or
         ((yA + hA) > yB and (yA + hA) < (yB + hB))) then
    return 1
  end
  return 0
end

function gameOver ()
  isGameOver = true
  --print("Game Over")
end

function wonGame ()
  isWinner = true
  --print("Won Game")
end

function love.load()
  
  isGameOver, isWinner = false,false
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  placeElements()
  
end

function love.keypressed(key)
  --if key == 'right'  then
  --  player.move(0)
  --end
  --if key == 'up'  then
  --  player.move(1)
  --end
  --if key == 'left'  then
  --  player.move(2)
  --end
  --if key == 'down'  then
  --  player.move(3)
  --end

end

function love.mousepressed(x, y, button, istouch)
 
end

function love.update (dt)
  
  if isGameOver == false and  isWinner == false then
    
    for i = 1, #noteslist do
      noteslist[i]:update()
    end
  end
  
end

function love.draw ()
  if isGameOver == false then
    love.graphics.setBackgroundColor(0,0,0)
    --love.graphics.rectangle("fill", 0,0,screenWidth,screenHeight)
  end
  for i = 1, #baseList do
      baseList[i].draw()
  end
  for i = 1, #noteslist do
      noteslist[i].draw()
  end
end