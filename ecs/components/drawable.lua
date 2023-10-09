local path = (...):gsub(".ecs.components.drawable$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")

local drawableGroup = newGroup("drawable")

event.define("entityDraw")

event.on("draw", function()
  drawableGroup:sortBy("zIndex", 0)
  for entity in drawableGroup:iter() do
    event.call("entityDraw", entity)
  end
end)
