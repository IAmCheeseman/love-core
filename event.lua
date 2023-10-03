local event = {}

local events = {}

function event.define(name)
  if events[name] then
    error(("Event '%s' already defined."):format(name))
  end

  local newEvent = {
    callbacks = {}
  }
  events[name] = newEvent
end

function event.on(name, callback)
  if not events[name] then
    error(("Event '%s' does not exist."):format(name))
  end

  table.insert(events[name].callbacks, callback)
end

function event.call(name, ...)
  if not events[name] then
    error(("Event '%s' does not exist."):format(name))
  end

  for _, callback in ipairs(events[name].callbacks) do
    callback(...)
  end
end

return event
