local path = (...):gsub(".ecs.ecs$", "")
local event = require(path .. ".event.event")
local utils = require(path .. ".utils")
local newQueue = require(path .. ".types.queue")

local ecs = {}

local additionQueue = newQueue()
local removalQueue = newQueue()

event.define("entityAdded")
event.define("entityRemoved")
event.define("entityChanged")
event.define("entitiesCleared")

local instances = {}
ecs.instances = instances

function ecs.addEntity(entity)
  additionQueue:push(entity)
end

function ecs.removeEntity(entity)
  removalQueue:push(entity)
end

function ecs.clearEntities()
  for _, entity in ipairs(instances) do
    ecs.removeEntity(entity)
  end
  ecs.flushQueues()
  event.call("entitiesCleared")
end

local function flushAdditionQueue(entity)
  table.insert(instances, entity)
  entity.__instanceIndex = #instances

  event.call("entityAdded", entity)
end

local function flushRemovalQueue(entity)
  utils.swapRemove(instances, entity.__instanceIndex)

  event.call("entityRemoved", entity)
end

function ecs.flushQueues()
  additionQueue:flush(flushAdditionQueue)
  removalQueue:flush(flushRemovalQueue)
end

return ecs
