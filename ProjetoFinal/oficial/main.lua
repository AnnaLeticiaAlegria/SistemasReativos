function startGameScene ()
  
  return {
    draw = function ()
      love.graphics.setBackgroundColor(0.5,0.3,0)
      
      love.graphics.setColor(255,255,255)
      font = love.graphics.newFont(40)
      love.graphics.setFont(font)
      love.graphics.printf("Musicas", 0, screenHeight/3, screenWidth/2, 'center')
      music1Button = love.graphics.newImage( "easybutton.png" )
      love.graphics.draw(music1Button, screenWidth/8,screenHeight/1.5)
      music2Button = love.graphics.newImage( "mediumbutton.png" )
      love.graphics.draw(music2Button, screenWidth/2.5,screenHeight/1.5)
      music3Button = love.graphics.newImage( "hardbutton.png" )
      love.graphics.draw(music3Button, screenWidth/1.5,screenHeight/1.5)
    end,
    setMode = function (mode)
      enemyNumber = mode
      placeElements()
      isStartScene = false
    end,
    getPositionAndSize = function (button)
      if button == 1 then
        return screenWidth/8,screenHeight/1.5, 157,50
      elseif button == 2 then
        return screenWidth/2.5,screenHeight/1.5, 157,50
      else
        return screenWidth/1.5,screenHeight/1.5, 157,50
      end
    end
  }
  end


function gameScene ()
  
  return {
    draw = function ()
      love.graphics.setBackgroundColor(0,0,0)
      
      love.graphics.setColor(255,255,255)
      font = love.graphics.newFont(40)
      love.graphics.setFont(font)
      love.graphics.printf("choose the game mode", 0, screenHeight/3, screenWidth, 'center')
      easyButton = love.graphics.newImage( "easybutton.png" )
      love.graphics.draw(easyButton, screenWidth/8,screenHeight/1.5)
      mediumButton = love.graphics.newImage( "mediumbutton.png" )
      love.graphics.draw(mediumButton, screenWidth/2.5,screenHeight/1.5)
      hardButton = love.graphics.newImage( "hardbutton.png" )
      love.graphics.draw(hardButton, screenWidth/1.5,screenHeight/1.5)
    end,
    setMode = function (mode)
      enemyNumber = mode
      placeElements()
      isStartScene = false
    end,
    getPositionAndSize = function (button)
      if button == 1 then
        return screenWidth/8,screenHeight/1.5, 157,50
      elseif button == 2 then
        return screenWidth/2.5,screenHeight/1.5, 157,50
      else
        return screenWidth/1.5,screenHeight/1.5, 157,50
      end
    end
  }
end


function createNote ()
  
  local w, h = 30, 30
  local actualDirection,changeDirection = 0,0
  local speed, maxChange = math.random(15), math.random(1,50,100)
  local maxDx = speed * maxChange
  local maxX = screenWidth - (w + maxDx)
  local randX = love.math.random(maxX)
  local maxY = screenHeight - (h + maxDx)
  local randY = love.math.random(maxY)
  local posX, posY = randX, randY
  local first = os.clock()
  
  local wait = function (sec)
    first = os.clock() + sec
    coroutine.yield()
  end
    
  return {
    draw = function ()
      if isGameOver == false and isWinner == false then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill",posX,posY, w,h)
      end
    end,
    setPosition = function (x,y)
      posX,posY = x,y
    end,
    getSize = function ()
      return w,h
    end,
    move =  coroutine.wrap( function (self)
      while true do
        if (actualDirection == 0) then
          posX = posX + speed
          changeDirection = changeDirection + 1
        elseif (actualDirection == 1) then
          posY = posY + speed
          changeDirection = changeDirection + 1
        elseif(actualDirection == 2) then
          posX = posX - speed
          changeDirection = changeDirection + 1
        else
          posY = posY - speed
          changeDirection = changeDirection + 1
        end
        if(changeDirection > maxChange) then
          changeDirection = 0
          actualDirection = actualDirection + 1
          if (actualDirection > 3) then
            actualDirection = 0
          end
        end
        wait(speed/10000)
      end
     end),
    getPosition = function ()
      return posX, posY
    end,
    isPlayerAlive = function ()
      
        if(os.clock() > first) then
          return true
        end
      return false
    end
  } 
end

function createProgressBar ()
  
  local w,h = 20, 20
  local speed = 5
  local posX, posY = (screenWidth - w), (screenHeight - h)

  return {
    draw = function ()
      if isGameOver == false then
        love.graphics.setColor(0,0,255)
        love.graphics.rectangle("fill",posX,posY, w,h)
      end
    end,
    setPosition = function (x,y)
      posX,posY = x,y
    end,
    getSize = function ()
      return w,h
    end,
    move = function (direction)
        if (direction == 0) and ((posX + w) < screenWidth) then
          posX = posX + speed
        elseif (direction == 1) and ((posY) > 0) then
          posY = posY - speed
        elseif(direction == 2) and ((posX) > 0) then
          posX = posX - speed
        elseif (direction == 3) and ((posY + h) < screenHeight) then
          posY = posY + speed
        end
    end,
    getPosition = function ()
      return posX, posY
    end
  }
end

function createSucessBar ()
  local w,h = 10, 10
  local maxX = screenWidth - (w)
  local randX = love.math.random(maxX)
  local maxY = screenHeight/2 - (h)
  local randY = love.math.random(maxY)
  local posX, posY = randX, randY
  
  return {
    draw = function ()
      if isDoorOpen == false and isGameOver == false then
        love.graphics.setColor(0,255,0)
        love.graphics.rectangle("fill",posX,posY, w,h)
      end
    end,
    setPosition = function (x,y)
      posX,posY = x,y
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
  
  enemylist = {}
  
  for i = 1,enemyNumber do
    enemylist[i] = createEnemy()
  end
  
  player = createPlayer()
  
  key = createKey()
  
  door = createDoor()

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
  

function gotKey ()
  --print("Got Key")
  isDoorOpen = true
end

function love.load()
  
  isGameOver, isDoorOpen, isWinner = false,false,false
  isStartScene = true
  
  enemyNumber = 3
  
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  startScene = startGameScene()
  
  --placeElements()
  
end

function checkPlayerMove ()
  if love.keyboard.isDown( 'right' ) then
    player.move(0)
  end
  if love.keyboard.isDown( 'up' ) then
    player.move(1)
  end
  if love.keyboard.isDown( 'left' ) then
    player.move(2)
  end
  if love.keyboard.isDown( 'down' ) then
    player.move(3)
  end
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
  
  if (isGameOver == true or isWinner == true) and key == 'return' then
    isGameOver = false
    isDoorOpen = false
    isWinner = false
    isStartScene = true
  end

end

function love.mousepressed(x, y, button, istouch)
     
    if isStartScene == true and button == 1 then
      local b1X, b1Y, b1W, b1H = startScene.getPositionAndSize(1)
      local b2X, b2Y, b2W, b2H = startScene.getPositionAndSize(2)
      local b3X, b3Y, b3W, b3H = startScene.getPositionAndSize(3)
      
      if(x > b1X and x < b1X + b1W) and (y > b1Y and y < b1Y + b1H) then
        startScene.setMode(3)
      elseif (x > b2X and x < b2X + b2W) and (y > b2Y and y < b2Y + b2H) then
        startScene.setMode(5)
      elseif (x > b3X and x < b3X + b3W) and (y > b3Y and y < b3Y + b3H) then
        startScene.setMode(7)
      end
    end
end

function love.update (dt)
  
  if isGameOver == false and isStartScene == false and isWinner == false then
    
    for i = 1, #enemylist do
      if (enemylist[i].isPlayerAlive()) then
        enemylist[i]:move()
      end
    end
  
    checkPlayerMove ()
    
    --checa colisão do player com os inimigos
    local playerX, playerY = player.getPosition()
    local playerW, playerH = player.getSize()
  
    for i = 1, #enemylist do
      local enemyX, enemyY = enemylist[i].getPosition()
      local enemyW, enemyH = enemylist[i].getSize()
      if (collision (playerX,playerY,playerW,playerH,enemyX,enemyY,enemyW,enemyH) == 1) then
        gameOver()
      end
    end
  
    local keyX, keyY = key.getPosition()
    local keyW, keyH = key.getSize()
    if (collision (keyX,keyY,keyW,keyH, playerX,playerY,playerW,playerH) == 1) then
      gotKey ()
    end
    
    if isDoorOpen == true then 
      local doorX, doorY = door.getPosition()
      local doorW, doorH = door.getSize()
      if (collision (doorX,doorY,doorW,doorH, playerX,playerY,playerW,playerH) == 1 or 
          collision (playerX,playerY,playerW,playerH, doorX,doorY,doorW,doorH) == 1) then
        wonGame ()
      end
    end
  end
  
end

function love.draw ()
  if isGameOver == false then
    love.graphics.setBackgroundColor(0,0,0)
    --love.graphics.rectangle("fill", 0,0,screenWidth,screenHeight)
  end
  if isStartScene == false then
    door.draw()
  
    for i = 1, #enemylist do
      enemylist[i].draw()
    end
  
    player.draw()
    key.draw()
  else
    startScene.draw()
  end 
  if isGameOver == true then
    --love.graphics.setColor(43,36,50)
    --love.graphics.rectangle("fill",0,0, screenWidth,screenHeight)
    love.graphics.setColor(255,255,255)
    font = love.graphics.newFont(40)
    love.graphics.setFont(font)
    love.graphics.printf("game over", 0, screenHeight/2.5, screenWidth, 'center')
    font2 = love.graphics.newFont(20)
    love.graphics.setFont(font2)
    love.graphics.printf("press enter to start again", 0, screenHeight/2, screenWidth, 'center')
  end
  
  if isWinner == true then
    love.graphics.setColor(255,255,255)
    font = love.graphics.newFont(40)
    love.graphics.setFont(font)
    love.graphics.printf("you won!!", 0, screenHeight/2.5, screenWidth, 'center')
    font2 = love.graphics.newFont(20)
    love.graphics.setFont(font2)
    love.graphics.printf("press enter to start again", 0, screenHeight/2, screenWidth, 'center')
  end
end