local posX = 350
local posY = 500
local nbrBlockRow = 10
local nbrBlockCol = 10
local nbrBlock = nbrBlockCol * nbrBlockRow
local blockwidth = 80
local blockheight = 20
local done = 0
local speed = 1
local check = {}
local block = {}
local font
ball_x = 250
ball_y = 300
ball_dx = 3
ball_dy = -3
circle_size = 10


function love.keypressed(key, isrepeat)
  if (key == "escape") then
    love.event.quit()
  end
  if (key == "a") then
    ball_dy = ball_dy + speed
    ball_dx = ball_dx + speed
  end
  if (key == "z") then
    ball_dx = ball_dx - 1
    ball_dy = ball_dy - 1
  end
  if (key == "r") then
    ball_x = 250
    ball_y = 300
    ball_dx = 3
    ball_dy = -3
    posX = 350
    posY = 500
    check_wall(nbrBlockRow, nbrBlockCol)
  end
end

function move_player()
  if love.keyboard.isDown("left") then
    if (posX > 0) then
      posX = posX - 5
    end
  end
  if love.keyboard.isDown("right") then
    if (posX < love.graphics.getWidth() - blockwidth) then
      posX = posX + 5
    end
  end
end

function create_rectangle(posiX, posiY, color)
  if (color == 0) then
    love.graphics.setColor(0, 0, 0)
  else
    love.graphics.setColor(0, 255, 255)      
  end
  love.graphics.rectangle("fill", posiX, posiY, blockwidth, blockheight)  
end

  

function create_wall(row, column)
  local x = 0
  local y = 0
  colorw = 255
  
  
  for i=1, column do
    x = 0
    for j=1, row do
      if (check[i][j] == 0) then
        create_rectangle(x, y, colorw)
      end
      x = x + blockwidth + 1
    end
    y = y + blockheight + 1
  end
end

function check_wall(row, column)
  local x = 0
  local y = 0
  local count = 1

  for i=1, column do
    x = 0
    check[i] = {}
    for j=1, row do
      check[i][j] = 0
      x = x + blockwidth + 1
      count = count + 1
    end
    y = y + blockheight + 1
  end
end

function create_ball(x, y)
  if (ball_y < love.graphics.getHeight()) then
    love.graphics.setColor(255, 153, 50)
    love.graphics.circle("fill", x, y, circle_size)
  else
    love.graphics.setColor(0, 0, 0)
  end
end

function check_impact()
  local x = 1
  local y = 1
  local count = 1
    
  if (ball_y > posY and ball_x >= posX and ball_x <= posX + blockwidth) then
      ball_dy  = -ball_dy
  end
  
    
  for i=1, nbrBlockCol do
    x = 0
    for j=1, nbrBlockRow do
      tmp = check[i][j]
      if (tmp == 0) then
        if (ball_y < y + blockheight and ball_x >= x and ball_x <= x + blockwidth) then
            ball_dy  = -ball_dy
            check[i][j] = 1
        end
      end
      x = x + blockwidth + 1
      count = count + 1
    end
    y = y + blockheight + 1
  end
end

function move_ball()
  if (ball_x > love.graphics.getWidth() or ball_x < 0) then
    ball_dx  = -ball_dx
  end
  ball_x = ball_x + ball_dx
  if (ball_y < 0) then
    ball_dy = -ball_dy
  end
  ball_y = ball_y - ball_dy  
end

function love.load()
  love.window.setTitle("Breakout Game")
  icon = love.image.newImageData("media/index.jpeg")
  love.window.setIcon(icon)
  check_wall(nbrBlockRow, nbrBlockCol)
  font = love.graphics.newFont("media/font.ttf", 50)
end

function love.update(dt)
  if (ball_y < love.graphics.getHeight()) then
    move_player()
    move_ball()
    check_impact()
  end
end

function love.draw()
  create_rectangle(posX, posY)
  create_wall(nbrBlockRow, nbrBlockCol)
  create_ball(ball_x, ball_y)
  if (ball_y >= love.graphics.getHeight()) then
    love.graphics.setColor(255, 0, 0)
    love.graphics.setFont(font)
    love.graphics.print("Press r to reset the game !", 
                        love.graphics.getWidth() / 4,
                        love.graphics.getHeight() / 2)
  end
end