local path = (...):gsub(".ecs.group$", "")
local event = require(path .. ".event")
local newSparseSet = require(path .. ".types.sparse_set")
local utils = require(path .. ".utils")

local groups = {}

local groupMt = {}
groupMt.__index = groupMt

local function callEvent(t, ...)
  for _, c in ipairs(t) do
    c(...)
  end
end

local function addEntityToGroups(entity)
  for _, group in ipairs(groups) do
    if group:entityMatches(entity) then
      group:add(entity)
      callEvent(group.addedCallbacks, entity)
    end
  end
end

event.on("entityAdded", addEntityToGroups)
event.on("entityChanged", function(entity)
  addEntityToGroups(entity)
end)

event.on("entityRemoved", function(entity)
  for _, group in ipairs(groups) do
    if group:has(entity) then
      group:remove(entity)
      callEvent(group.removedCallbacks, entity)
    end
  end
end)

function groupMt:add(entity)
  if self.entities:has(entity) then
    return
  end
  self.entities:add(entity)
end

function groupMt:has(entity)
  return self.entities:has(entity)
end

function groupMt:remove(entity)
  self.entities:remove(entity)
end

function groupMt:onAdded(fn)
  table.insert(self.addedCallbacks, fn)
end

function groupMt:onRemoved(fn)
  table.insert(self.removedCallbacks, fn)
end

function groupMt:requireTag(tag)
  local applyTag = function(entity)
    if not entity[tag] then
      entity[tag] = true
      event.call("entityChanged", entity)
    end
  end
  self:onAdded(applyTag)

  for i in self:iter() do
    applyTag(i)
  end
end

function groupMt:sortBy(component, default)
  self.entities:sort(function(a, b)
    return (a[component] or default) < (b[component] or default)
  end)
end

function groupMt:iter()
  return self.entities:iter()
end

function groupMt:entityMatches(entity)
  if self.entities:has(entity) then
    return false
  end

  for _, component in ipairs(self.components) do
    if not entity[component] then
      return false
    end
  end
  return true
end

local function newGroup(...)
  local group = setmetatable({
    components = {...},
    entities = newSparseSet(),
    addedCallbacks = {},
    removedCallbacks = {},
  }, groupMt)

  table.insert(groups, group)
  return group
end

return newGroup
