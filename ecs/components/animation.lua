local path = (...):gsub(".ecs.components.animation$", "")
local event = require(path .. ".event")
local utils = require(path .. ".utils")

local animGroup = Group("x", "y", "sprite")

event.on("update", function(dt)
  for entity in animGroup:iter() do
    entity.sprite:update(dt)
  end
end)

event.on("draw", function()
  for entity in animGroup:iter() do
    entity.scalex = entity.scalex or 1
    entity.scaley = entity.scaley or 1
    entity.rotation = entity.rotation or 0

    entity.sprite:draw(
        entity.x, entity.y,
        entity.rotation,
        entity.scalex, entity.scaley)
  end
end)


local animPrioritiesGroup = Group("animation", "sprite")

event.on("update", function(_)
  for entity in animPrioritiesGroup:iter() do
    local highestPriority = -math.huge
    local properties
    local play = ""

    for name, animation in pairs(entity.animation) do
      local shouldPlay = animation.shouldPlay
      if type(shouldPlay) == "function" then
        shouldPlay = shouldPlay(entity)
      end

      if shouldPlay and animation.priority > highestPriority then
        play = name
        highestPriority = animation.priority
        properties = animation.properties
      end
    end

    utils.nilCall(properties, entity)
    entity.sprite:play(play)
  end
end)
