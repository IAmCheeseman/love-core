local path = (...):gsub(".ecs.components.drawable$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")

local drawableGroup = newGroup("drawable")

event.define("preEntityDraw")
event.define("entityDraw")
event.define("postEntityDraw")

event.on("draw", function()
  drawableGroup:sortBy("zIndex", 0)
  for entity in drawableGroup:iter() do
    event.call("preEntityDraw", entity)
    event.call("entityDraw", entity)
    event.call("postEntityDraw", entity)
  end
end)
