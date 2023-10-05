local path = (...):gsub(".ecs.components.movement$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")

local moveGroup = newGroup("x", "y", "vx", "vy")

event.on("update", function(dt)
  for entity in moveGroup:iter() do
    entity.x = entity.x + entity.vx * dt
    entity.y = entity.y + entity.vy * dt
  end
end)
