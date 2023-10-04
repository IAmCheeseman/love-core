local path = (...):gsub(".ecs.ecs$", "")
local Queue = require(path .. ".types.queue")
local event = require(path .. ".event")
local utils = require(path .. ".utils")

local ecs = {}

local additionQueue = Queue()
local removalQueue = Queue()

event.define("entityAdded")
event.define("entityRemoved")
event.define("entityChanged")

local instances = {}
ecs.instances = instances

function ecs.addEntity(entity)
  additionQueue:enqueue(entity)
end

function ecs.removeEntity(entity)
  removalQueue:enqueue(entity)
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
