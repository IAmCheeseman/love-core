local path = (...):gsub(".ecs.entity$", "")
local ecs = require(path .. ".ecs.ecs")
local utils = require(path .. ".utils")

local function Entity(definition)
  return function()
    return utils.deepCopy(definition)
  end
end

return Entity
