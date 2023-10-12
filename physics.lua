local path = (...):gsub(".physics$", "")
local event = require(path .. ".event")

local physics = {}

local world = love.physics.newWorld(0, 0)
physics.world = world

local drawCollisions = false

function physics.resetWorld(gx, gy, sleep)
  world = love.physics.newWorld(gx, gy, sleep)
  physics.world = world
end

local function newObject(type, shape)
  local object = {}
  object.body = love.physics.newBody(world, 0, 0, type)
  object.shape = shape
  object.fixture = love.physics.newFixture(object.body, shape)
  return object
end

function physics.newDynamicObject(shape)
  return newObject("dynamic", shape)
end

function physics.newStaticObject(shape)
  return newObject("static", shape)
end

function physics.newKinematicObject(shape)
  return newObject("kinematic", shape)
end

event.on("update", math.huge, function(dt)
  world:update(dt)
end)

event.on("keyPressed", function(key, isRepeat)
  if key == "f1" and not isRepeat then
    drawCollisions = not drawCollisions
  end
end)

event.on("draw", -math.huge, function()
  if not drawCollisions then
    return
  end
  love.graphics.setColor(1, 0, 0, 0.5)
  for _, body in ipairs(world:getBodies()) do
    for _, fixture in ipairs(body:getFixtures()) do
      local shape = fixture:getShape()
      local type = shape:getType()
      if type == "circle" then
        love.graphics.circle("fill", body:getX(), body:getY(), shape:getRadius())
      elseif type == "polygon" then
        love.graphics.polygon(
            "fill", body:getWorldPoints(shape:getPoints()))
      end
    end
  end

  love.graphics.setColor(1, 1, 1)
end)

return physics
