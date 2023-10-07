local path = (...):gsub(".state$", "")
local event = require(path .. ".event")
local utils = require(path .. ".utils")
local ecs = require(path .. ".ecs.ecs")

local state = {}

event.define("stateChanged")

local currentState = "none"
local gameStates = {}

local gameState = {}
gameState.__index = gameState

function state.getCurrent()
  return gameStates[currentState]
end

function state.setCurrent(name)
  currentState = name
  utils.nilCall(state.getCurrent().initialize)
  event.call("stateChanged", name)
  ecs.clearEntities()
end

function state.newState(name)
  local newState = {}
  gameStates[name] = newState

  return newState
end

function gameState:clear()
  self.entities = {}
  event.call("stateCleared", self)
end

event.on("update", function(dt)
  utils.nilCall(state.getCurrent().update, dt)
end)

event.on("draw", function()
  utils.nilCall(state.getCurrent().draw)
end)

event.on("ui", function()
  utils.nilCall(state.getCurrent().ui)
end)

event.on("inkyUi", function()
  utils.nilCall(state.getCurrent().inkyUi)
end)

event.on("mousePressed", function(button)
  utils.nilCall(state.getCurrent().mousePressed, button)
end)

event.on("mouseReleased", function(button)
  utils.nilCall(state.getCurrent().mouseReleased, button)
end)

event.on("mouseMoved", function(dx, dy)
  utils.nilCall(state.getCurrent().mouseMoved, dx, dy)
end)

state.newState("none")

return state
