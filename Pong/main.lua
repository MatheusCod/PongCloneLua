function love.load()
  -- Window
  love.window.setTitle("Pong Clone")
  windowWidth = 800
  windowHeight = 500
  love.window.setMode(windowWidth, windowHeight)

  -- Player's size
  rect_width = 20
  rect_height = 100

  -- Players speed
  speed = 350

  -- Player 1
  player1 = {}
  player1.x = 30
  player1.y = math.floor((windowHeight - rect_height)/2)
  player1.score = 0

  -- Player 2
  player2 = {}
  player2.x = 750
  player2.y = math.floor((windowHeight - rect_height)/2)
  player2.score = 0

  -- Ball speed
  ball_speed = 200

  -- Ball
  ball = {}
  ball.size = 20
  ball.x = math.floor((windowWidth - ball.size)/2)
  ball.y = math.floor((windowHeight - ball.size)/2)

  vector_range = {}
  vector_range[0] = -1
  vector_range[1] = 1
  ball.vector = {}
  ball.vector[0] = vector_range[love.math.random(0,1)]
  ball.vector[1] = vector_range[love.math.random(0,1)]

  -- Score
  game_point = true
  wait_timer = 5
  score_font = love.graphics.setNewFont(50)

  -- Dotted line
  dotted_line = love.graphics.newCanvas(windowWidth, windowHeight)
  love.graphics.setCanvas(dotted_line)
    love.graphics.clear()
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(1, 0, 0, 0.5)
    y_jump = 0
    for i=0,34 do
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle("fill", 395, y_jump, 8, 8)
      y_jump = y_jump + 15
    end
  love.graphics.setCanvas()
end

function love.update(dt)

  if (game_point and wait_timer > 0) then
    wait_timer = wait_timer - dt*15
  else
    game_point = false
    -- Controllers
    if (love.keyboard.isDown("w") and player1.y > 0) then
      player1.y = player1.y - (speed * dt)
    end
    if (love.keyboard.isDown("s") and player1.y < windowHeight - rect_height) then
      player1.y = player1.y + (speed * dt)
    end
    if (love.keyboard.isDown("up") and player2.y > 0) then
      player2.y = player2.y - (speed * dt)
    end
    if (love.keyboard.isDown("down") and player2.y < windowHeight - rect_height) then
      player2.y = player2.y + (speed * dt)
    end

    -- Collisions
    if (
      ball.x <= player1.x + rect_width and
      ball.x > player1.x and
      ball.y >= player1.y and
      ball.y < player1.y + rect_height
    ) then
      ball.vector[0] = ball.vector[0] * -1
    elseif (
      ball.x + ball.size > player2.x and
      ball.x < player2.x and
      ball.y >= player2.y and
      ball.y < player2.y + rect_height
    ) then
      ball.vector[0] = ball.vector[0] * -1
    elseif (ball.y <= 0 or ball.y + ball.size >= windowHeight) then
      ball.vector[1] = ball.vector[1] * -1
    end

    -- Balls position
    ball.x  = ball.x + (ball_speed * dt) * ball.vector[0]
    ball.y  = ball.y + (ball_speed * dt) * ball.vector[1]

    -- Points
    if (ball.x > windowWidth) then
      player1.score = player1.score + 1
      game_point = true
      if (player1.score >= 10) then
        player1.score = 0
        player2.score = 0
      end
    end

    if (ball.x < 0) then
      player2.score = player2.score + 1
      game_point = true
      if (player2.score >= 10) then
        player1.score = 0
        player2.score = 0
      end
    end

    if (game_point) then
      ball.x = math.floor((windowWidth - ball.size)/2)
      ball.y = math.floor((windowHeight - ball.size)/2)
      game_point = true
      wait_timer = 10
    end

  end

end

function love.draw()

  -- "Reset" the background because of the use of canvas
  love.graphics.setColor(1,1,1,1)

  -- Dotted line
  --love.graphics.setBlendMode("alpha", "premultiplied") --Used to prevent improper blending
  love.graphics.draw(dotted_line)

  -- Players and Ball
  love.graphics.setColor(1,1,1)

  -- Player 1
  love.graphics.rectangle("fill", player1.x, player1.y, rect_width, rect_height)

  -- Player 2
  love.graphics.rectangle("fill", player2.x, player2.y, rect_width, rect_height)

  -- Ball
  love.graphics.rectangle("fill", ball.x, ball.y, ball.size, ball.size)

  -- Score
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(score_font)
  love.graphics.print(player1.score, 150, 20)
  love.graphics.print(player2.score, 620, 20)

end
