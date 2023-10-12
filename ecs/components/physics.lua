local path = (...):gsub(".ecs.components.physics$", "")
local newGroup = require(path .. ".ecs.group")
local physics = require(path .. ".physics")

-- FIXME
local physicsGroup = newGroup("physicsType", "physicsShape")

physicsGroup:onAdded(function(entity)
  if entity.physicsType == "dynamic" then
    entity.physicsObject = physics.newDynamicObject(entity.physicsShape)
  elseif entity.physicsType == "static" then
    entity.physicsObject = physics.newStaticObject(entity.physicsShape)
  end

  entity.physicsObject.body:setPosition(entity.x, entity.y)
end)
