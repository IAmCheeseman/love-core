local stack = {}
stack.__index = stack

function stack:push(item)
  table.insert(self.items, item)
end

function stack:pop()
  local item = self.items[#self.items]
  self.items[#self.items] = nil
  return item
end

function stack:flush(f)
  local item = self:pop()
  while item do
    f(item)
    item = self:pop()
  end
end

local function newStack()
  return setmetatable({
    items = {},
  }, stack)
end

return newStack
