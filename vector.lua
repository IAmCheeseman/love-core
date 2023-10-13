local vector = {}

--- Finds the length of a Vector
---@param x number
---@param y number
function vector.length(x, y)
  return math.sqrt(x ^ 2 + y ^ 2)
end

--- Reduces the length of a vector to 1
---@param x number
---@param y number
function vector.normalize(x, y)
  local l = vector.length(x, y)
  if l == 0 then
    return 0, 0
  end
  return x / l, y / l
end

--- Dot product
---@param x number
---@param y number
---@param xx number
---@param yy number
function vector.dot(x, y, xx, yy)
  return x * xx + y * yy
end

--- Finds the direction between two points
---@param x number
---@param y number
---@param xx number
---@param yy number
function vector.directionTo(x, y, xx, yy)
  return vector.normalize(xx - x, yy - y)
end

--- Finds the distance between two points
---@param x number
---@param y number
---@param xx number
---@param yy number
function vector.distanceBetween(x, y, xx, yy)
  return vector.length(x - xx, y - yy)
end

function vector.mDistanceBetween(x, y, xx, yy)
  return math.abs(x - xx) + math.abs(y - yy)
end

--- Find the angle of a vector
---@param x number
---@param y number
function vector.angle(x, y)
  local angle = math.atan2(y, x)
  if angle < 0 then
    angle = angle + math.pi * 2
  end
  return angle
end

--- Finds the angle between two points
---@param x number
---@param y number
---@param xx number
---@param yy number
function vector.angleBetween(x, y, xx, yy)
  return vector.angle(xx - x, yy - y)
end

--- Get a vector pointing in the direction the specified keys would make
---@param up string
---@param left string
---@param down string
---@param right string
function vector.getInputDirection(up, left, down, right)
  local ix, iy = 0, 0

  if love.keyboard.isDown(up) then iy = iy - 1 end
  if love.keyboard.isDown(left) then ix = ix - 1 end
  if love.keyboard.isDown(down) then iy = iy + 1 end
  if love.keyboard.isDown(right) then ix = ix + 1 end

  return ix, iy
end

--- A vector rotated by r
---@param x number
---@param y number
---@param r number
function vector.rotated(x, y, r)
  local newRot = vector.angle(x, y) + r
  local l = vector.length(x, y)

  local nx = math.cos(newRot) * l
  local ny = math.sin(newRot) * l

  return nx, ny
end

function vector.directionalInput(up, left, down, right)
  local ix, iy = 0, 0
  if love.keyboard.isDown(up) then
    iy = iy - 1
  end
  if love.keyboard.isDown(left) then
    ix = ix - 1
  end
  if love.keyboard.isDown(down) then
    iy = iy + 1
  end
  if love.keyboard.isDown(right) then
    ix = ix + 1
  end
  return core.vector.normalize(ix, iy)
end

return vector
