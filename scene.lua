local path = (...):gsub(".scene$", "")
local event = require(path .. ".event")
local utils = require(path .. ".utils")
local ecs = require(path .. ".ecs.ecs")

local scene = {}

event.define("stateChanged")

local currentState = "none"
local gameStates = {}

local gameState = {}
gameState.__index = gameState

function scene.getCurrent()
  return gameStates[currentState]
end

function scene.setCurrent(name)
  currentState = name
  utils.nilCall(scene.getCurrent().initialize)
  event.call("stateChanged", name)
  ecs.clearEntities()
end

function scene.newState(name)
  local newState = {}
  gameStates[name] = newState

  return newState
end

function gameState:clear()
  self.entities = {}
  event.call("stateCleared", self)
end

event.on("update", function(dt)
  utils.nilCall(scene.getCurrent().update, dt)
end)

event.on("draw", function()
  utils.nilCall(scene.getCurrent().draw)
end)

event.on("ui", function()
  utils.nilCall(scene.getCurrent().ui)
end)

event.on("inkyUi", function()
  utils.nilCall(scene.getCurrent().inkyUi)
end)

event.on("mousePressed", function(button)
  utils.nilCall(scene.getCurrent().mousePressed, button)
end)

event.on("mouseReleased", function(button)
  utils.nilCall(scene.getCurrent().mouseReleased, button)
end)

event.on("mouseMoved", function(dx, dy)
  utils.nilCall(scene.getCurrent().mouseMoved, dx, dy)
end)

scene.newState("none")

return scene
