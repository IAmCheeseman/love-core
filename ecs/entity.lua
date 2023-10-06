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
  return function()
    local ent = setmetatable(utils.deepCopy(definition), entityMt)
    return ent
  end
end

return newEntity
