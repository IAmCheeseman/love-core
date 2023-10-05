local path = (...):gsub(".init$", "")

local core = {}
core.event = require(path .. ".event")
core.viewport = require(path .. ".viewport")
core.assetLoader = require(path .. ".asset_loader")
core.vector = require(path .. ".vector")

core.newSparseSet = require(path .. ".types.sparse_set")
core.newQueue = require(path .. ".types.queue")

core.newEntity = require(path .. ".ecs.entity")
core.newGroup = require(path .. ".ecs.group")

core.log = require(path .. ".log")

local ecs = require(path .. ".ecs.ecs")

local utils = require(path .. ".utils")
utils.copyTo(utils, core)
utils.copyTo(require(path .. ".math_funcs"), core)

core.tickRate = 1 / 20
local tickDelta = 0
local runtime = 0

core.event.define("preUpdate")
core.event.define("update")
core.event.define("tick")

core.event.define("draw")
core.event.define("ui")

core.viewport.create("main", 320, 180, true)
core.viewport.create("gui", 320, 180)
core.viewport.setBackgroundColor("gui", 0, 0, 0, 0)

core.removeEntity = ecs.removeEntity

require(path .. ".ecs.components")
require(path .. ".error_handler")

function core.getRuntime()
  return runtime
end

function core.initialize()
end

function core.update(dt)
  core.event.call("preUpdate", dt)

  runtime = runtime + dt
  tickDelta = tickDelta + dt
  ecs.flushQueues()

  core.event.call("update", dt)
  if tickDelta >= core.tickRate then
    core.event.call("tick", core.tickRate)
    tickDelta = tickDelta - core.tickRate
  end
end

function core.draw()
  core.viewport.clear("main")
  core.viewport.drawTo("main", function()
    core.event.call("draw")
  end)

  core.viewport.clear("gui")
  core.viewport.drawTo("gui", function()
    core.event.call("ui")
  end)

  core.viewport.draw("main")
  core.viewport.draw("gui")
end

return core
