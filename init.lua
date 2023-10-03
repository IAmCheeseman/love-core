local path = (...):gsub(".init$", "")
local ecs = require(path .. ".ecs.ecs")

local core = {}
core.event = require(path .. ".event")

core.Entity = require(path .. ".ecs.entity")
core.Group = require(path .. ".ecs.group")

core.SparseSet = require(path .. ".types.sparse_set")
core.Queue = require(path .. ".types.queue")

local utils = require(path .. ".utils")
utils.copyTo(utils, core)
utils.copyTo(require(path .. ".math_funcs"), core)

core.tickRate = 1 / 20
local tickDelta = 0

core.event.define("preUpdate")
core.event.define("update")
core.event.define("tick")

core.event.define("draw")
core.event.define("ui")

function core.initialize()
end

function core.update(dt)
  core.event.call("preUpdate", dt)

  tickDelta = tickDelta + dt
  ecs.flushQueues()

  core.event.call("update", dt)
  if tickDelta >= core.tickRate then
    core.event.call("tick", core.tickRate)
    tickDelta = tickDelta - core.tickRate
  end
end

function core.draw()
  core.event.call("draw")
  core.event.call("ui")
end

return core
