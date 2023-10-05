local queue = {}
queue.__index = queue

function queue:push(item)
  table.insert(self.items, item)
end

function queue:pop()
  local item = self.items[1]
  table.remove(self.items, 1)
  return item
end

function queue:flush(f)
  local item = self:pop()
  while item do
    f(item)
    item = self:pop()
  end
end

local function Queue()
  return setmetatable({
    items = {},
  }, queue)
end

return Queue
