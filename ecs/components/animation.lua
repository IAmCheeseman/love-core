local path = (...):gsub(".ecs.components.animation$", "")
local event = require(path .. ".event")
local utils = require(path .. ".utils")

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
