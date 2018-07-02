local leit, esc

function createTimeBar ()
  local wA,wB,h = screenWidth/1.8, 0 , 20 
  local posXa, posY = screenWidth/4, screenHeight/16
  local posXb = screenWidth/4
  local firstTime
  local pace = (screenWidth/1.8)/89
  
  return {
    draw = function ()
      love.graphics.setColor(255,255,255)
      love.graphics.rectangle("fill", posXa,posY,wA,h)
      if (initiateMusic == false) then
        love.graphics.setColor(0,255,0)
        love.graphics.rectangle("fill", posXb,posY,wB,h)
      end
      if isGameOver == true then
        
        love.graphics.setColor(255,255,255)
        font = love.graphics.newFont(40)
        love.graphics.setFont(font)
        love.graphics.printf(progressBar.getScore() , screenWidth/4, screenHeight/2 , screenWidth, 'center')
        font = love.graphics.newFont(35)
        love.graphics.setFont(font)
        love.graphics.printf("score "..points, screenWidth/4, screenHeight/2 + 50, screenWidth, 'center')
      end
    end,
    setFirstTime = function ()
      firstTime = love.timer.getTime()
    end,
    reset = function ()
      wA, wB = screenWidth/1.8, 0
      posXa = screenWidth/4
    end,
    update = function ()
      if wA > 0 then
        if initiateMusic == false and (love.timer.getTime() - firstTime) > 1 then
          firstTime = love.timer.getTime()
          wA = wA - pace
          posXa = posXa + pace
          wB = wB + pace
        end
      else
        isGameOver = true
      end
    end
  }
end

function createProgressBar ()
  local wA,wB,h = screenWidth/1.8, 0 , 10 
  local posXa, posY = screenWidth/4, screenHeight/10
  local posXb = screenWidth/4
  local pace = (screenWidth/1.8)/totalNotes
  local goodSignal, greatSignal = screenWidth/4 + 0.6*screenWidth/1.8, screenWidth/4 + 0.85*screenWidth/1.8
  
  return {
    draw = function ()
      love.graphics.setColor(255,255,255)
      love.graphics.rectangle("fill", posXa,posY,wA,h)
      if (wB > 0) then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill", posXb,posY,wB,h)
      end
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.rectangle("fill", goodSignal,posY,5,10)
      love.graphics.rectangle("fill", greatSignal,posY,5,10)
    end,
    update = function (points)
      wB = wB + ( (points/50) * pace)
      if wB < 0 then
        wB = 0
        wA = screenWidth/1.8
        posXa = screenWidth/4
      else
        wA = wA - ( (points/50) * pace)
        posXa = posXa + ( (points/50) * pace)
      end
    end,
    getScore = function ()
      if screenWidth/4 + wB > greatSignal then
        return "great"
      elseif screenWidth/4 + wB > goodSignal then
        return "good"
      else
        return "fail"
      end
    end
  }
end

function createNote (noteTy)
  
  local w, h = 50, 50
  local posX, posY = 0, screenHeight/8.0
  local speed = (80.0/(3*screenHeight))
  local noteType = noteTy
  local fileName
  local isVisible = true
  
  local first = love.timer.getTime()
  
  local wait = function (sec)
    first = love.timer.getTime( ) + sec
    coroutine.yield()
  end
  
  if noteType == 1 then
    fileName = "nota1a.png"
    posX = screenWidth/4
  elseif noteType == 2 then
    fileName = "nota2a.png"
    posX = screenWidth/2
  else
    fileName = "nota3a.png"
    posX = screenWidth*3/4
  end

  return {
    draw = function ()
      if isGameOver == false and isWinner == false and isVisible == true then
        love.graphics.setColor(255,255,255)
        local musicButton = love.graphics.newImage( fileName )
        love.graphics.draw(musicButton, posX, posY)--, nil, w/500, h/500)
      end
    end,
    getSize = function ()
      return h
    end,
    update =  coroutine.wrap( function (self)
      while true do
        posY = posY + 5
        --wait(1/10000, self)
        wait(speed,self)
      end
    end),
    getPosition = function ()
      return posY
    end,
    getType = function ()
      return noteType
    end,
    getVisible = function ()
      return isVisible
    end,
    changeVisible = function ()
      isVisible = false
    end,
    isNoteDisplayed = function ()
      
        if(love.timer.getTime( ) > first) then
          return true
        end
      return false
    end,
    changeVisible = function ()
      isVisible = false
    end
  } 
end

function createBases (baseTy)
  
  local w, h = 50, 50
  local posX, posY = 0, globalBaseY
  local baseType = baseTy
  local fileName
  local message = ""
  
  if baseTy == 1 then
    fileName = "base1a.png"
    posX = screenWidth/4
  elseif baseTy == 2 then
    fileName = "base2a.png"
    posX = screenWidth/2
  else
    fileName = "base3a.png"
    posX = screenWidth*3/4
  end
  

  return {
    draw = function ()
      love.graphics.setColor(255,255,255)
      local baseButton = love.graphics.newImage( fileName )
      love.graphics.draw(baseButton, posX, posY)--, nil, w/500, h/500)
      font = love.graphics.newFont(15)
      love.graphics.setFont(font)
      love.graphics.printf(message, posX + 60, posY + 25, 60, 'left')
    end,
    getSize = function ()
      return w,h
    end,
    changeMessage = function(mess)
      message = mess
    end,
    getPositionY = function ()
      return posY
    end
  }
end

function readFile ()
  notesTypelist = {}
  notesInitialTimelist = {}
  myFile = io.open("notesData3.txt","r")
  local text, time, typeNotes, space
  totalNotes = 0
  for text in myFile:lines() do
    --text = myFile:read(1)
    space = string.find(text, " ")
    time = string.sub(text,1,space-1)
    typeNotes = string.sub(text,space + 1)
    --local randomDt = math.random(10,40) / 1000
    --local noteDt = 4--3/4*screenHeight / 200
    local noteTime = tonumber(time)
    if(noteTime < 0) then
      noteTime = 0
    end
    table.insert(notesTypelist, tonumber(typeNotes))
    table.insert(notesInitialTimelist, noteTime)
    totalNotes = totalNotes + 1
  end
  myFile:close()
end

function placeElements ()
  
  baseList = {}
  
  for i = 1, 3 do
    baseList[i] = createBases(i)
  end
  
  noteslist = {}
  
  timeBar = createTimeBar()
  progressBar = createProgressBar()
  
  --for i = 1,10 do
    --table.insert(noteslist, createNote(math.random(1,3), math.random(20)))
    --noteslist[i] = createNote(math.random(1,3), math.random(50))
  --end

end

function collision (yA,h,yB)

--print("Entrei na colision")
--print("xA: ".. xA .." yA: ".. yA .. " wA: " .. wA .. " hA: " ..hA);
--print("xB: "..xB .." yB: ".. yB .. " wB: " .. wB .. " hB: ".. hB);
  --if ((yA < (yB + h) and yA > yB) or
  --       ((yA + h) > yB and (yA + h) < (yB + h))) then
  if ( ((yA + h) >= yB and yA <= yB) or
            (yA <= (yB + h) and (yA+h) >= (yB + h))) then
    return math.abs(yA - yB)
  end
  return -1
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
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  globalBaseY = screenHeight* 7/8.0
  
  readFile ()
  leit = io.open("/dev/cu.usbmodem1421","r")
  esc = io.open("/dev/cu.usbmodem1421","w")
  
  isGameOver, isWinner = false,false
  
  
  placeElements()
  
  points = 0
  
  currentNote = 1
  
  start = false
  initiateMusic = true
  
  deadNotes = 1
  firststeptime = love.timer.getTime()
  speed = (80.0/(3*screenHeight))
  
  readTime = love.timer.getTime()
  firstDrawTime1 = love.timer.getTime()
  firstDrawTime2 = love.timer.getTime()
  firstDrawTime3 = love.timer.getTime()
end

function love.keypressed(key)
  if key == 'return' then
    start = true
    firstTime = love.timer.getTime( )
  end
  
end

function checkCollision (noteTy, posY)
  local minDist = screenHeight
  local minI = -1
  local dist
  for i = deadNotes, #noteslist do
      local ty = noteslist[i].getType()
      local vi = noteslist[i].getVisible()
      if vi == true and ty == noteTy then
        local yA = noteslist[i].getPosition()
        local hA = noteslist[i].getSize()
        dist = collision (yA,hA,posY)
        if (dist > 0) then
          if (dist < minDist) then
            minDist = dist
            minI = i
          end
        end
      end
  end
  if minI < 0 then
    return -1, -1
  end
  return minDist, minI
end

function checkNotesPos ()
  
  for i = deadNotes, #noteslist do
    if noteslist[i].getPosition() > screenHeight then
      if(noteslist[i].getVisible() == true) then
         points = points - 20
         progressBar.update(-20)
       end
      noteslist[i].changeVisible()
      deadNotes = i
      
    end
  end
end

function love.update (dt)
  
  if(start == true) then
    if love.timer.getTime() - firstTime > 5.1 and initiateMusic == true then
      esc:write("1")
      esc:write(dt)
      initiateMusic = false
      timeBar.setFirstTime()
    end
    if currentNote <= totalNotes then
      if notesInitialTimelist[currentNote] < (love.timer.getTime( ) - firstTime) then
        table.insert(noteslist, createNote(notesTypelist[currentNote] ))
        currentNote = currentNote + 1
      end
    end
  end
  
  timeBar.update()
  if initiateMusic == false then
    serial = leit:read(1)
    --print(serial)
    local deltaY, pos
    if serial=='1' then 
      deltaY, pos = checkCollision (1, globalBaseY)
      firstDrawTime1 = love.timer.getTime()
    elseif serial == '2' then
      deltaY, pos = checkCollision (2, globalBaseY)
      firstDrawTime2 = love.timer.getTime()
    elseif serial == '3' then
      deltaY, pos = checkCollision (3, globalBaseY) 
      firstDrawTime3 = love.timer.getTime()
    end

  
    if serial ~= '0' then  
      --print(deltaY.." "..serial)
      if deltaY < 0 then
          points = points - 20
          --baseList[tonumber(serial)].changeMessage("miss")
          --esc:write("2")
      else
        local bonus
        if deltaY <= 10 then
          bonus = 50
          baseList[tonumber(serial)].changeMessage("perfect!")
        elseif deltaY <= 20 then
          bonus = 40
          baseList[tonumber(serial)].changeMessage("great!")
        elseif deltaY <= 35 then
          bonus = 30
          baseList[tonumber(serial)].changeMessage("cool!")
        elseif deltaY <= 45 then
          bonus = 20
          baseList[tonumber(serial)].changeMessage("ok")
        else
          bonus = -20
          baseList[tonumber(serial)].changeMessage("miss")
          --esc:write("2")
        end
      
        progressBar.update(bonus)
        points = points + bonus
        noteslist[pos].changeVisible()
      end
      readTime = love.timer.getTime()
    end
  end
  
  checkNotesPos()
  
  if isGameOver == false and  isWinner == false then
    
    for i = deadNotes, #noteslist do
       if (noteslist[i].isNoteDisplayed()) then
        noteslist[i]:update()
      end
    end
  end
  if love.timer.getTime() - firstDrawTime1 > 1 then
      baseList[1].changeMessage("")
      firstDrawTime1 = love.timer.getTime()
  end
  if love.timer.getTime() - firstDrawTime2 > 1 then
      baseList[2].changeMessage("")
      firstDrawTime2 = love.timer.getTime()
  end
  if love.timer.getTime() - firstDrawTime3 > 1 then
      baseList[3].changeMessage("")
      firstDrawTime3 = love.timer.getTime()
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
  for i = deadNotes, #noteslist do
      noteslist[i].draw()
  end
  --love.graphics.setColor(255,255,255)
  --font = love.graphics.newFont(40)
  --love.graphics.setFont(font)
  --love.graphics.printf("points "..points, 0, screenHeight/3, screenWidth/4, 'left')
  
  timeBar.draw()
  progressBar.draw()
  
end

