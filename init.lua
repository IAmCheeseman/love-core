local path = (...):gsub(".init$", "")

local ecs = require(path .. ".ecs.ecs")

local core = {}
core.event = require(path .. ".event.event")
core.collectors = require(path .. ".event.collectors")
core.question = require(path .. ".event.question")

core.event.define("preUpdate")
core.event.define("update")
core.event.define("tick")

core.event.define("draw")
core.event.define("ui")
core.event.define("inkyUi")

core.event.define("keyPressed")
core.event.define("keyReleased")
core.event.define("mousePressed")
core.event.define("mouseReleased")
core.event.define("mouseMoved")

core.viewport = require(path .. ".viewport")
core.assetLoader = require(path .. ".asset_loader")
core.physics = require(path .. ".physics")
core.component = require(path .. ".ecs.component")
core.math = require(path .. ".mathf")

core.newSparseSet = require(path .. ".types.sparse_set")
core.newStack = require(path .. ".types.stack")
core.newQueue = require(path .. ".types.queue")
core.newTimer = require(path .. ".timer")

core.newEntity = require(path .. ".ecs.entity")
core.newGroup = require(path .. ".ecs.group")

core.scene = require(path .. ".scene")
core.state = require(path .. ".state")

local utils = require(path .. ".utils")
utils.copyTo(utils, core)

core.tickRate = 1 / 20
local tickDelta = 0
local runtime = 0

core.viewport.create("main", 320, 180, true)
core.viewport.create("gui", 320, 180)
core.viewport.setBackgroundColor("gui", 0, 0, 0, 0)

core.removeEntity = ecs.removeEntity
core.addEntity = ecs.addEntity

require(path .. ".ecs.components")
core.inky = require(path .. ".thirdparty.inky")
core.ui = require(path .. ".ui")

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

    core.ui.begin()
    core.event.call("inkyUi")
    core.ui.finish()
  end)

  core.viewport.draw("main")
  core.viewport.draw("gui")

  love.graphics.reset()
end

function core.keyPressed(key, isRepeat)
  core.event.call("keyPressed", key, isRepeat)
end

function core.keyReleased(key)
  core.event.call("keyReleased", key)
end

function core.mousePressed(button)
  core.event.call("mousePressed", button)
end

function core.mouseReleased(button)
  core.event.call("mouseReleased", button)
end

function core.mouseMoved(dx, dy)
  core.event.call("mouseMoved", dx, dy)
end

return core
