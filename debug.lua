local path = (...):gsub(".debug$", "")
local event = require(path .. ".event.event")
local physics = require(path .. ".physics")
local theme = require(path .. ".ui.theme")

local debugOn = false

event.on("keyPressed", function(key, isRepeat)
  if key == "f2" then
    debugOn = not debugOn
  end
end)

event.on("ui", function()
  if not debugOn then
    return
  end

  local y = 0
  love.graphics.setFont(theme.font)
  local h = theme.font:getHeight()
  local name, version, _, device = love.graphics.getRendererInfo()

  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, y)
  y = y + h
  love.graphics.print(name .. " " .. version, 0, y)
  y = y + h
  love.graphics.print(device, 0, y)
  y = y + h
  love.graphics.print("Physics Bodies: " .. physics.world:getBodyCount(), 0, y)
end)
