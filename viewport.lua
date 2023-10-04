local path = (...):gsub(".viewport$", "")
local m = require(path .. ".math_funcs")
local utils = require("core.utils")

local viewport = {}

local viewports = {}

local function generateCanvas(v)
  local cw, ch = v.width, v.height
  if v.smoothCamera then
    cw = cw + 1
    ch = ch + 1
  end
  v.canvas = love.graphics.newCanvas(cw, ch)
end

local function getViewportTransform(name)
  local v = viewports[name]
  local sw, sh = v.width, v.height
  local ww, wh = love.graphics.getDimensions()

  local w, h = ww, wh
  local scale = w / sw < h / sh
      and w / sw
      or  h / sh
  w = sw * scale
  h = sh * scale
  local x, y = (ww - w) / 2, (wh - h) / 2
  return x, y, scale
end

function viewport.getCameraPos(name)
  local v = viewports[name]
  return v.camerax, v.cameray
end

function viewport.setCameraPos(name, x, y)
  local v = viewports[name]
  v.camerax, v.cameray = x, y
end

function viewport.setSize(name, w, h)
  local v = viewports[name]
  v.width, v.height = w, h
  generateCanvas(v)
end

function viewport.getSize(name)
  local v = viewports[name]
  return v.width, v.height
end

function viewport.setBackgroundColor(name, r, g, b, a)
  viewports[name].backgroundColor = { r, g, b, a or 1 }
end

function viewport.getBackgroundColor(name)
  local color = viewports[name].backgroundColor
  return color[1], color[2], color[3], color[4] or 1
end

function viewport.clear(name)
  viewport.drawTo(name, function()
    love.graphics.clear(unpack(viewports[name].backgroundColor))
  end)
end

function viewport.drawTo(name, f)
  viewports[name].canvas:renderTo(f)
end

function viewport.getMousePosition(name)
  local v = viewports[name]
  local x, y, scale = getViewportTransform(name)
  local mx, my = love.mouse.getPosition()
  mx = mx - x
  my = my - y

  mx = math.floor(v.camerax + mx / scale)
  my = math.floor(v.cameray + my / scale)
  return mx, my
end

function viewport.draw(name)
  local v = viewports[name]
  local x, y, scale = getViewportTransform(name)

  local quad
  if v.smoothCamera then
    quad = love.graphics.newQuad(
        m.frac(v.camerax), m.frac(v.cameray),
        v.width, v.height,
        v.width + 1, v.height + 1)
  else
    quad = love.graphics.newQuad(
        0, 0, v.width, v.height, v.width, v.height)
  end

  love.graphics.draw(v.canvas, quad, x, y, 0, scale)
end

function viewport.create(name, width, height, smoothCamera)
  smoothCamera = smoothCamera or false

  viewports[name] = {
    width = width,
    height = height,
    camerax = 0,
    cameray = 0,
    backgroundColor = { 0, 0, 0, 1 },
    smoothCamera = smoothCamera,
  }
  generateCanvas(viewports[name])
end

return viewport
