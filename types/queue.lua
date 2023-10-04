local queue = {}
queue.__index = queue

function queue:enqueue(item)
  table.insert(self.items, item)
end

function queue:dequeue()
  local item = self.items[#self.items]
  self.items[#self.items] = nil
  return item
end

function queue:flush(f)
  local item = self:dequeue()
  while item do
    f(item)
    item = self:dequeue()
  end
end

local function Queue()
  return setmetatable({
    items = {},
  }, queue)
end

return Queue
