local path = (...):gsub(".ecs.components.camera$", "")
local event = require(path .. ".event")
local newGroup = require(path .. ".ecs.group")
local viewport = require(path .. ".viewport")

local cameraGroup = newGroup("camera", "x", "y")

event.on("update", -1, function(_)
  for entity in cameraGroup:iter() do
    local width, height = viewport.getSize(entity.camera)
    viewport.setCameraPos(
        entity.camera,
        entity.x - width / 2,
        entity.y - height / 2)
  end
end)
