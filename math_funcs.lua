local math = {}

function math.frac(x)
  return x - math.floor(x)
end

function math.lerp(a, b, t)
  return (b - a) * (1 - 0.5^t) + a
end

function math.wrap(a, min, max)
  return (a % (max - min)) + min
end

function math.clamp(a, min, max)
  if a > max then
    return max
  elseif a < min then
    return min
  end
  return a
end

return math
