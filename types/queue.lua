local queueMetatable = {
  __index = function(k, v)
    return v.items[k]
  end,
  __newindex = function(_, _, _)
    error("Queues are readonly!")
  end
}

local function enqueue(self, item)
  table.insert(self.items, item)
end

local function dequeue(self)
  local item = self.items[#self.items]
  self.items[#self.items] = nil
  return item
end

local function flush(self, f)
  local item = self:dequeue()
  while item do
    f(item)
    item = self:dequeue()
  end
end

local function Queue()
  return setmetatable({
    items = {},

    enqueue = enqueue,
    dequeue = dequeue,
    flush = flush
  }, queueMetatable)
end

return Queue
