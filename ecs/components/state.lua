local path = (...):gsub(".ecs.components.state$", "")
local event = require(path .. ".event.event")
local newGroup = require(path .. ".ecs.group")
local state = require(path .. ".state")

local stateGroup = newGroup("state")

local previousStates = {}


event.on("update", function(dt)
  for entity in stateGroup:iter() do
    local previous = previousStates[entity]
    local current = entity.state

    if previous ~= current then
      if state.canEnter(entity, current) then
        if previous then
          state.call(previous, "exit", entity)
        end
        state.call(current, "enter", entity)
      else
        entity.state = previous
        current = previous
      end
    end

    state.call(current, "update", dt, entity)

    previousStates[entity] = current
  end
end)

event.on("entityDraw", function(entity)
  if stateGroup:has(entity) then
    state.call(entity.state, "draw", entity)
  end
end)

