local path = (...):gsub(".ecs.component$", "")
local utils = require(path .. ".utils")

local component = {}

local definitions = {}

function component.new(name, definition)
  definitions[name] = definition
end

local function overrideTable(override, t)
  for k, v in pairs(override) do
    if type(v) == "table" then
      overrideTable(v, t)
    else
      t[k] = v
    end
  end
end

function component.create(name, overrides)
  overrides = overrides or {}
  local c = utils.deepCopy(definitions[name])
  overrideTable(overrides, c)
  return c
end

return component
