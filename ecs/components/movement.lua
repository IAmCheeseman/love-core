local path = (...):gsub(".ecs.components.movement$", "")
local event = require(path .. ".event.event")
local newGroup = require(path .. ".ecs.group")

local moveGroup = newGroup("x", "y", "physics")

event.on("update", function(dt)
  for entity in moveGroup:iter() do
    entity.x = entity.physics.object.body:getX() + (entity.physics.offsetx or 0)
    entity.y = entity.physics.object.body:getY() + (entity.physics.offsety or 0)
  end
end)
