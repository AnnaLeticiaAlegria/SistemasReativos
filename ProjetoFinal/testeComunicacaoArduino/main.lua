local mostrabaleia = true
local baleia
local W, H = 400, 300
local leit, esc

local function toggle ()
  mostrabaleia = not mostrabaleia
end

function love.load() -- (Arduino/Genuino Mega or Mega 2560)
  leit = io.open("/dev/cu.usbmodem1421","r")
  esc = io.open("/dev/cu.usbmodem1421","w")
  baleia = love.graphics.newImage("whale.png")
  love.window.setMode(W,H)
  love.graphics.setBackgroundColor (1, 1, 0)
end

function love.update(dt)
  a = leit:read(1)
  print(a)
  if a=='1' then toggle() end
end

function love.draw()
  if mostrabaleia then
    love.graphics.draw(baleia, W/3, H/3, 0, 0.5)
  end
end

function love.keypressed (k)
  if k  == "return" then esc:write("1\n") end
end
