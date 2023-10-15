local path = (...):gsub(".ecs.components.movement$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")

local moveGroup = newGroup("x", "y", "vx", "vy")

event.on("update", function(dt)
  for entity in moveGroup:iter() do
    if entity.physics then
      entity.physics.object.body:setLinearVelocity(entity.vx, entity.vy)
      entity.x = entity.physics.object.body:getX() + (entity.physics.offsetx or 0)
      entity.y = entity.physics.object.body:getY() + (entity.physics.offsety or 0)
    else
      entity.x = entity.x + entity.vx * dt
      entity.y = entity.y + entity.vy * dt
    end
  end
end)
