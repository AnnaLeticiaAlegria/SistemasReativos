function love.load()
  --x = 50 y = 200
  --w = 200 h = 150
  
  ret1 = retangulo (50,200,200,150)
  ret2 = retangulo (200,50,200,150)
  
  retArray = {retangulo(10,10,100,50), retangulo(10,50,100,50)}
end

function naimagem (mx, my, x, y, w, h) 
  return (mx>x) and (mx<x+w) and (my>y) and (my<y+h)
end

function retangulo (x, y, w ,h)
  
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  return {
    draw = 
      function()
        love.graphics.rectangle("line", rx, ry, rw, rh)
      end,
    keypressed = 
      function(key)
        local mx, my = love.mouse.getPosition() 
        if key == 'b' and naimagem (mx,my, rx, ry, rw, rh) then
          ry = 200
        end
        if key == "down" and naimagem(mx,my, rx, ry, rw, rh) then
          ry = ry + 10
        end
        if key == "right" and naimagem(mx,my, rx, ry, rw, rh) then
          rx = rx + 10
        end
      end,
    update = 
      function()
          local mx, my = love.mouse.getPosition() 
      end
  }
  
end

function love.keypressed(key)
  ret1.keypressed(key)
  ret2.keypressed(key)
  
  for i=1, #retArray do
    retArray[i].keypressed(key)
  end
end

function love.update (dt)
  ret1.update()
  ret2.update()

  for i=1, #retArray do
    retArray[i].update()
  end
end

function love.draw ()
  ret1.draw()
  ret2.draw()
  
  for i=1, #retArray do
    retArray[i].draw()
  end
end