local path = (...):gsub(".error_handler", "")
local log = require(path .. ".log")
local utf8 = require("utf8")

local function errorPrinter(msg, layer)
  print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
  msg = tostring(msg)

  errorPrinter(msg, 2)

  if not love.window or not love.graphics or not love.event then
    return
  end

  if not love.graphics.isCreated() or not love.window.isOpen() then
    local success, status = pcall(love.window.setMode, 800, 600)
    if not success or not status then
      return
    end
  end

  -- Reset state.
  if love.mouse then
    love.mouse.setVisible(true)
    love.mouse.setGrabbed(false)
    love.mouse.setRelativeMode(false)
    if love.mouse.isCursorSupported() then
      love.mouse.setCursor()
    end
  end

  if love.joystick then
    -- Stop all joystick vibrations.
    for _, v in ipairs(love.joystick.getJoysticks()) do
      v:setVibration()
    end
  end

  if love.audio then
    love.audio.stop()
  end

  love.graphics.reset()
  local _ = love.graphics.setNewFont(14)

  love.graphics.setColor(1, 1, 1)

  local trace = debug.traceback()

  love.graphics.origin()

  local sanitizedMessage = {}
  for char in msg:gmatch(utf8.charpattern) do
    table.insert(sanitizedMessage, char)
  end
  ---@diagnostic disable-next-line: cast-local-type
  sanitizedMessage = table.concat(sanitizedMessage)

  local err = {}

  table.insert(err, "Error\n")
  table.insert(err, sanitizedMessage)

  if #sanitizedMessage ~= #msg then
    table.insert(err, "Invalid UTF-8 string in error message.")
  end

  table.insert(err, "\n")

  for l in trace:gmatch("(.-)\n") do
    if not l:match("boot.lua") then
      l = l:gsub("stack traceback:", "Traceback\n")
      table.insert(err, l)
    end
  end

  local p = table.concat(err, "\n")

  p = p:gsub("\t", "")
  p = p:gsub("%[string \"(.-)\"%]", "%1")

  local canvas = love.graphics.newCanvas(love.graphics.getDimensions())

  local draw = function()
    if not love.graphics.isActive() then
      return
    end
    local pos = 50

    love.graphics.setCanvas(canvas)

    love.graphics.clear(0, 0, 0, 0)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle(
        "fill",
        pos - 5, pos - 5,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() - pos * 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(p, pos, pos, love.graphics.getWidth() / 2)

    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0)

    love.graphics.present()
  end

  local fullErrorText = p
  local function copyToClipboard()
    if not love.system then return end
    love.system.setClipboardText(fullErrorText)
    p = p .. "\nCopied to clipboard!"
  end

  if love.system then
    p = p .. "\n\nPress Ctrl+C or tap to copy this error"
  end

  return function()
    love.event.pump()

    for e, a, _, _ in love.event.poll() do
      if e == "quit" then
        return 1
      elseif e == "keypressed" and a == "escape" then
        return 1
      elseif e == "keypressed" and a == "r" then
        return "restart"
      elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
        copyToClipboard()
      elseif e == "touchpressed" then
        local name = love.window.getTitle()
        if #name == 0 or name == "Untitled" then name = "Game" end
        local buttons = {"OK", "Cancel"}
        if love.system then
          buttons[3] = "Copy to clipboard"
        end
        local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
        if pressed == 1 then
          return 1
        elseif pressed == 3 then
          copyToClipboard()
        end
      end
    end

    draw()

    if love.timer then
      love.timer.sleep(0.1)
    end
  end

end
