function love.load()
  core.initialize()
end

function love.update(dt)
  core.update(dt)
end

function love.draw()
  core.draw()
end

function love.keypressed(key, _, isRepeat)
  core.keyPressed(key, isRepeat)
end

function love.keyreleased(key, _)
  core.keyReleased(key)
end

function love.mousepressed(_, _, button)
  core.mousePressed(button)
end

function love.mousereleased(_, _, button)
  core.mouseReleased(button)
end

function love.mousemoved(_, _, dx, dy)
  core.mouseMoved(dx, dy)
end
