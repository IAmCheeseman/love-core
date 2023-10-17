local path = (...):gsub(".ui$", "")
local inky = require(path .. ".thirdparty.inky")
local event = require(path .. ".event.event")
local utils = require(path .. ".utils")

local scene = inky.scene()
local pointer = inky.pointer(scene)

local ui = {}

ui.kirigami = require(path .. ".thirdparty.kirigami")

local button = require(path .. ".ui.button")
local label = require(path .. ".ui.label")

function ui.button(text, settings)
  settings = settings or {}
  local newButton = button(scene)
  newButton.props.text = text
  utils.copyTo(settings, newButton.props)
  return newButton
end

function ui.label(text, settings)
  settings = settings or {}
  local newLabel = label(scene)
  newLabel.props.text = text
  utils.copyTo(settings, newLabel.props)
  return newLabel
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
