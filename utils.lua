local utils = {}

function utils.swapRemove(t, i)
  t[i] = t[#t]
  t[#t] = nil
end

function utils.copy(t)
  local copy = {}

  for k, v in pairs(t) do
    copy[k] = v
  end

  local mt = getmetatable(t)
  if mt then
    setmetatable(copy, mt)
  end

  return copy
end

function utils.deepCopy(t)
  local copy = {}

  for k, v in pairs(t) do
    if type(v) == "table" then
      copy[k] = utils.deepCopy(v)
    else
      copy[k] = v
    end
  end

  local mt = getmetatable(t)
  if mt then
    setmetatable(copy, mt)
  end

  return copy
end

function utils.tableErase(t, item)
  for i, v in ipairs(t) do
    if v == item then
      table.remove(t, i)
      return
    end
  end
end

function utils.printTable(t, indents)
  indents = indents or 1
  local indent = "  "

  print("{")
  for k, v in pairs(t) do
    if type(v) == "table" then
      io.write(("%s%s = "):format(indent:rep(indents), tostring(k)))
      utils.printTable(v, indents + 1)
      print(",")
    elseif type(v) == "string" then
      print(("%s%s = \"%s\","):format(indent:rep(indents), tostring(k), tostring(v)))
    else
      print(("%s%s = %s,"):format(indent:rep(indents), tostring(k), tostring(v)))
    end
  end
  io.write(("%s}"):format(indent:rep(indents - 1)))
  if indents == 1 then
    print()
  end
end

function utils.nilCall(f, ...)
  if f then
    return f(...)
  end
  return nil
end

function utils.setIfNil(t, k, v)
  if t[k] then
    return false
  end
  t[k] = v
  return true
end

function utils.copyTo(src, dst)
  for k, v in pairs(src) do
    dst[k] = v
  end
end

function utils.hexToRgba(hex)
  hex = hex:gsub("#","")
  return
    tonumber("0x" .. hex:sub(1,2)) / 255,
    tonumber("0x" .. hex:sub(3,4)) / 255,
    tonumber("0x" .. hex:sub(5,6)) / 255,
    tonumber("0x" .. hex:sub(7,8)) / 255
end

return utils
