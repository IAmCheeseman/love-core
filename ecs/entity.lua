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

local function newEntity(definition)
  return function(overrides)
    overrides = overrides or {}
    local ent = setmetatable(utils.deepCopy(definition), entityMt)
    for k, v in pairs(overrides) do
      ent[k] = v
    end
    return ent
  end
end

return newEntity
