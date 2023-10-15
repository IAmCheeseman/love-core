local mathf = {}

function mathf.frac(x)
  return x - math.floor(x)
end

function mathf.lerp(a, b, t)
  return (b - a) * t + a
end

function mathf.angleDiff(a, b)
  local diff = (b - a) % (math.pi * 2)
  return (2 * diff) % (math.pi * 2) - diff
end

function mathf.lerpAngle(a, b, t)
  return a + mathf.angleDiff(a, b) * (1 - 0.5^t)
end

function mathf.wrap(a, min, max)
  return (a % (max - min)) + min
end

function mathf.clamp(a, min, max)
  if a > max then
    return max
  elseif a < min then
    return min
  end
  return a
end

function mathf.step(a, by)
  return math.floor((a / by) + 0.5) * by
end

function mathf.length(x, y)
  return math.sqrt(x ^ 2 + y ^ 2)
end

function mathf.normalize(x, y)
  local l = mathf.length(x, y)
  if l == 0 then
    return 0, 0
  end
  return x / l, y / l
end

function mathf.dot(x, y, xx, yy)
  return x * xx + y * yy
end

function mathf.directionTo(x, y, xx, yy)
  return mathf.normalize(xx - x, yy - y)
end

function mathf.distanceBetween(x, y, xx, yy)
  return mathf.length(x - xx, y - yy)
end

function mathf.mDistanceBetween(x, y, xx, yy)
  return math.abs(x - xx) + math.abs(y - yy)
end

function mathf.angle(x, y)
  local angle = math.atan2(y, x)
  if angle < 0 then
    angle = angle + math.pi * 2
  end
  return angle
end

function mathf.angleBetween(x, y, xx, yy)
  return mathf.angle(xx - x, yy - y)
end

function mathf.getInputDirection(up, left, down, right)
  local ix, iy = 0, 0

  if love.keyboard.isDown(up) then iy = iy - 1 end
  if love.keyboard.isDown(left) then ix = ix - 1 end
  if love.keyboard.isDown(down) then iy = iy + 1 end
  if love.keyboard.isDown(right) then ix = ix + 1 end

  return ix, iy
end

function mathf.rotated(x, y, r)
  local newRot = mathf.angle(x, y) + r
  local l = mathf.length(x, y)

  local nx = math.cos(newRot) * l
  local ny = math.sin(newRot) * l

  return nx, ny
end

function mathf.directionalInput(up, left, down, right)
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
  return mathf.normalize(ix, iy)
end


return mathf
