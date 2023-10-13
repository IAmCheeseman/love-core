local state = {}

local states = {}

function state.create(name)
  states[name] = {
    enterCallbacks = {},
    updateCallbacks = {},
    drawCallbacks = {},
    exitCallbacks = {},
  }
end

function state.onEnter(name, callback)
  table.insert(states[name].enterCallbacks, callback)
end

function state.onUpdate(name, callback)
  table.insert(states[name].updateCallbacks, callback)
end

function state.onDraw(name, callback)
  table.insert(states[name].drawCallbacks, callback)
end

function state.onExit(name, callback)
  table.insert(states[name].exitCallbacks, callback)
end

function state.call(name, callbackType, ...)
  local callbacks = callbackType .. "Callbacks"
  local s = states[name]
  if not s then
    error("State '" .. tostring(name) .. "' doesn't exist")
  end
  if not s[callbacks] then
    error("Invalid callback type.")
  end

  for _, callback in ipairs(s[callbacks]) do
    callback(...)
  end
end

return state
