local path = (...):gsub(".timer$", "")
local event = require(path .. ".event.event")

local timers = {}

event.on("update", math.huge, function(dt)
  for _, t in ipairs(timers) do
    t.justOver = false
    if not t.isOver then
      t.timeLeft = t.timeLeft - dt
      if t.timeLeft <= 0 then
        t.isOver = true
        t.justOver = true

        if t.autoRestart then
          t:start()
        end
      end
    end

  end
end)

local timer = {}
timer.__index = timer

function timer:start(time)
  time = time or self.waitTime
  self.timeLeft = time
  self.isOver = false
end

local function newTimer(time)
  local t = setmetatable({
    timeLeft = 0,
    waitTime = time,
    autoRestart = false,

    isOver = true,
    justOver = false,
  }, timer)

  table.insert(timers, t)

  return t
end

return newTimer
