local m = {}

function m.frac(x)
  return x - math.floor(x)
end

function m.lerp(a, b, t)
  return (b - a) * t + a
end

function m.angleDiff(a, b)
  local diff = (b - a) % (math.pi * 2)
  return (2 * diff) % (math.pi * 2) - diff
end

function m.lerpAngle(a, b, t)
  return a + m.angleDiff(a, b) * (1 - 0.5^t)
end

function m.wrap(a, min, max)
  return (a % (max - min)) + min
end

function m.clamp(a, min, max)
  if a > max then
    return max
  elseif a < min then
    return min
  end
  return a
end

function m.step(a, by)
  return math.floor((a / by) + 0.5) * by
end

return m
