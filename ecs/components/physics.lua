local path = (...):gsub(".ecs.components.physics$", "")
local newGroup = require(path .. ".ecs.group")
local physics = require(path .. ".physics")

local physicsGroup = newGroup("physics")

physicsGroup:onAdded(function(entity)
  local shape = entity.physics.shape
  assert(shape, "You must define a physics shape")
  local p = entity.physics

  local object
  local physicsType = p.type or "dynamic"
  if physicsType == "dynamic" then
    object = physics.newDynamicObject(shape)
  elseif physicsType == "static" then
    object = physics.newStaticObject(shape)
  end

  object.body:setPosition(entity.x, entity.y)
  object.body:setFixedRotation(p.fixedRotation or false)
  -- I weigh 74.84274kg
  object.body:setMass(p.mass or 74.84274)
  object.fixture:setRestitution(p.bounciness or 0)
  object.fixture:setFriction(p.friction or 0)

  entity.physics.object = object
end)

physicsGroup:onRemoved(function(entity)
  entity.physics.object.body:destroy()
  entity.physics = nil
end)
