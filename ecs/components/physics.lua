local path = (...):gsub(".ecs.components.physics$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")
local physics = require(path .. ".physics")

local physicsGroup = newGroup("physicsType", "physicsShape")

physicsGroup:onAdded(function(entity)
  if entity.physicsType == "dynamic" then
    entity.physicsObject = physics.newDynamicObject(entity.physicsShape)
  end
end)
