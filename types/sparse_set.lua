local path = (...):gsub(".types.sparse_set$", "")
local utils = require(path .. ".utils")

local function get(self, item)
  return self.dense[self.sparse[item]]
end

local function add(self, item)
  table.insert(self.dense, item)
  self.sparse[item] = #self.dense
end

local function remove(self, item)
  local index = self.sparse[item]
  utils.swapRemove(self.dense, index)

  local newItem = self.dense[index]
  self.sparse[newItem] = index
end

local function has(self, item)
  return self.sparse[item] ~= nil
end

local function SparseSet()
  return {
    sparse = {},
    dense = {},

    add = add,
    get = get,
    remove = remove,
    has = has,
  }
end

return SparseSet

