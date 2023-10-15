local path = (...):gsub(".ecs.entity$", "")
local utils = require(path .. ".utils")
local event = require(path .. ".event.event")

event.define("entityChanged")

local entityMt = {
  __newindex = function(t, k, v)
    if k ~= "__instanceIndex" then
      event.call("entityChanged", t)
    end
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
