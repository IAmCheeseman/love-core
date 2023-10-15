local collectors = {}

function collectors.OR(a, b)
  return a or b
end

function collectors.AND(a, b)
  return a and b
end

function collectors.SUM(a, b)
  return a + b
end

function collectors.MULT(a, b)
  return a * b
end

function collectors.EXP(a, b)
  return a^b
end

function collectors.TABLE(a, b)
  table.insert(a, b)
  return a
end

return collectors
