local event = {}

local events = {}

function event.define(name)
  if events[name] then
    return
  end

  local newEvent = {
    callbacks = {}
  }
  events[name] = newEvent
end

function event.on(...)
  local name, priority, callback
  local args = {...}
  if #args == 2 then
    name = args[1]
    priority = 0
    callback = args[2]
  elseif #args == 3 then
    name = args[1]
    priority = args[2]
    callback = args[3]
  end

  if not events[name] then
    error(("Event '%s' does not exist."):format(name))
  end

  table.insert(events[name].callbacks, {
    method = callback,
    priority = priority,
  })
end

function event.call(name, ...)
  if not events[name] then
    error(("Event '%s' does not exist."):format(name))
  end

  table.sort(events[name].callbacks, function(a, b)
    return a.priority > b.priority
  end)

  for _, callback in ipairs(events[name].callbacks) do
    callback.method(...)
  end
end

return event
