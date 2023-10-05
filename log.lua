local log = {}

local logFile = "log.txt"

local function logText(type, text)
  local time = os.date("*t")
  local formattedText = ("[%s %d:%d:%d] "):format(
      type, time.hour, time.min, time.sec) .. text
  print(formattedText)
  local res, error = love.filesystem.append(logFile, formattedText .. "\n")
  if not res then
    log.error("Failed to write to log: " .. error)
  end
end

function log.info(text)
  logText("INFO", text)
end

function log.warning(text)
  logText("WARNING", text)
end

function log.error(text)
  logText("ERR", text)
end

function log.fatal(text)
  logText("FATAL", text)
end

return log
