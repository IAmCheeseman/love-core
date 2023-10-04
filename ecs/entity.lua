local path = (...):gsub(".ecs.entity$", "")
local ecs = require(path .. ".ecs.ecs")
local utils = require(path .. ".utils")
local event = require(path .. ".event")

event.define("entityChanged")

local entityMt = {
  __newindex = function(t, k, v)
    event.call("entityChanged", t)
    rawset(t, k, v)
  end
}

local function Entity(definition)
  return function()
    local newEntity = setmetatable(utils.deepCopy(definition), entityMt)
    ecs.addEntity(newEntity)
    return newEntity
  end
end

return Entity
