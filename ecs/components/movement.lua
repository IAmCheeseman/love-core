local path = (...):gsub(".ecs.components.movement$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")

local moveGroup = newGroup("x", "y", "vx", "vy")

event.on("update", function(dt)
  for entity in moveGroup:iter() do
    if entity.physicsObject then
      entity.physicsObject.body:setLinearVelocity(entity.vx, entity.vy)
      entity.x = entity.physicsObject.body:getX() + (entity.physicsOffsetX or 0)
      entity.y = entity.physicsObject.body:getY() + (entity.physicsOffsetY or 0)
    else
      entity.x = entity.x + entity.vx * dt
      entity.y = entity.y + entity.vy * dt
    end
  end
end)
