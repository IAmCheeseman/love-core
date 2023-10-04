local path = (...):gsub(".ecs.group$", "")
local event = require(path .. ".event")

local groups = {}

local groupMt = {}
groupMt.__index = groupMt

local function addEntityToGroups(entity)
  for _, group in ipairs(groups) do
    if group:entityMatches(entity) then
      group:add(entity)
    end
  end
end

event.on("entityAdded", addEntityToGroups)
event.on("entityChanged", addEntityToGroups)

event.on("entityRemoved", function(entity)
  for _, group in ipairs(groups) do
    if group:has(entity) then
      group:remove(entity)
    end
  end
end)

function groupMt:add(entity)
  self.entities:add(entity)
end

function groupMt:has(entity)
  return self.entities:has(entity)
end

function groupMt:remove(entity)
  self.entities:remove(entity)
end

function groupMt:iter()
  return self.entities:iter()
end

function groupMt:entityMatches(entity)
  for _, component in ipairs(self.components) do
    if not entity[component] then
      return false
    end
  end
  return true
end

local function Group(...)
  local newGroup = setmetatable({
    components = {...},
    entities = SparseSet(),
  }, groupMt)

  table.insert(groups, newGroup)
  return newGroup
end

return Group
