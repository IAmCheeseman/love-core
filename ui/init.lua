local path = (...):gsub(".ui$", "")
local inky = require(path .. ".thirdparty.inky")
local event = require(path .. ".event")

local scene = inky.scene()
local pointer = inky.pointer(scene)

local ui = {}
ui.button = require(path .. ".ui.button")
ui.label = require(path .. ".ui.label")

for k, v in pairs(ui) do
  ui[k] = function()
    return v(scene)
  end
end

ui.theme = require(path .. ".ui.theme")

function ui.begin()
  scene:beginFrame()
end

function ui.finish()
  scene:finishFrame()
end

event.on("update", function(_)
  local mx, my = core.viewport.getMousePosition("gui")
  pointer:setPosition(mx, my)
end)

event.on("mousePressed", function(button)
  if button == 1 then
    pointer:raise("press")
  end
end)

event.on("mouseReleased", function(button)
  if button == 1 then
    pointer:raise("release")
  end
end)

event.on("mouseMoved", function(dx, dy)
  if love.mouse.isDown(1) then
    pointer:raise("drag", dx, dy)
  end
end)

return ui
