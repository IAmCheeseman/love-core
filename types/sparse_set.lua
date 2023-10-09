local path = (...):gsub(".types.sparse_set$", "")
local utils = require(path .. ".utils")

local sparseSet = {}
sparseSet.__index = sparseSet
sparseSet.__len = function(t)
  return #t.dense
end

function sparseSet:get(item)
  return self.dense[self.sparse[item]]
end

function sparseSet:add(item)
  if self:has(item) then
    return
  end
  table.insert(self.dense, item)
  self.sparse[item] = #self.dense
end

function sparseSet:remove(item)
  local index = self.sparse[item]
  utils.swapRemove(self.dense, index)

  local newItem = self.dense[index]
  self.sparse[newItem] = index
end

function sparseSet:sort(fn)
  table.sort(self.dense, fn)
  for i, v in ipairs(self.dense) do
    self.sparse[v] = i
  end
end

function sparseSet:has(item)
  return self.sparse[item] ~= nil
end

function sparseSet:iter()
  local i = 0
  return function()
    i = i + 1
    return self.dense[i]
  end
end

local function SparseSet()
  return setmetatable({
    sparse = {},
    dense = {},
  }, sparseSet)
end

return SparseSet

