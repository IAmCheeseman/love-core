local path = (...):gsub(".types.sprite$", "")
local loadAse = require(path .. ".thirdparty.lovease")
local utils = require(path .. ".utils")

local IMAGE_CHUNK = 0x2005
local TAG_CHUNK = 0x2018

local sprite = {}
sprite.__index = sprite
sprite.copy = utils.deepCopy

local function newSprite(spritePath)
  local file = loadAse(spritePath)

  local width = file.header.width
  local height = file.header.height
  local frames = {}
  local tags = {}
  local currentAnimation = ""

  for _, frame in ipairs(file.header.frames) do
    for _, chunk in ipairs(frame.chunks) do
      if chunk.type == IMAGE_CHUNK then
        local cell = chunk.data
        local buffer = love.data.decompress("data", "zlib", cell.data)
        local data = love.image.newImageData(
            cell.width, cell.height, "rgba8", buffer)
        local image = love.graphics.newImage(data)
        local canvas = love.graphics.newCanvas(width, height)

        canvas:renderTo(function()
          love.graphics.draw(image, cell.x, cell.y)
        end)

        table.insert(frames, {
          image = canvas,
          duration = frame.frame_duration / 1000
        })
      elseif chunk.type == TAG_CHUNK then
        for i, tag in ipairs(chunk.data.tags) do
          if i == 1 then
            currentAnimation = tag.name
          end

          tag.to = tag.to + 1
          tag.from = tag.from + 1
          tag.frameCount = tag.to - tag.from
          tags[tag.name] = tag
        end
      end
    end
  end

  return setmetatable({
    width = width,
    height = height,
    offsetx = 0,
    offsety = 0,
    frames = frames,
    tags = tags,
    currentAnimation = currentAnimation,
    frameIndex = 1,
    time = 0,
  }, sprite)
end

function sprite:play(name)
  assert(self.tags[name], ("Animation '%s' does not exist."):format(name))

  if self.currentAnimation == name then
    return
  end

  self.currentAnimation = name
  self.frameIndex = self.tags[name].from
end

function sprite:setOffsetPreset(horizontal, vertical)
  if horizontal == "left" then
    self.offsetx = 0
  elseif horizontal == "center" then
    self.offsetx = self.width / 2
  elseif horizontal == "right" then
    self.offsety = self.width
  else
    error("Invalid horizontal preset.")
  end

  if vertical == "top" then
    self.offsety = 0
  elseif vertical == "center" then
    self.offsety = self.height / 2
  elseif vertical == "bottom" then
    self.offsety = self.height
  else
    error("Invalid vertical preset.")
  end
end

function sprite:update(dt)
  if self.currentAnimation then
    local tag = self.tags[self.currentAnimation]

    if not tag then
      self.frameIndex = 1
      return
    end

    self.time = self.time + dt

    if self.time >= self.frames[self.frameIndex].duration then
      self.frameIndex = self.frameIndex + 1
      self.time = 0
      if self.frameIndex > tag.to then
        self.frameIndex = tag.from
      end
    end
  end
end

function sprite:draw(x, y, rotation, scalex, scaley)
  rotation = rotation or 0
  scalex = scalex or 1
  scaley = scaley or scalex

  love.graphics.draw(
      self.frames[self.frameIndex].image,
      x, y,
      rotation,
      scalex, scaley,
      self.offsetx, self.offsety)
end

return newSprite
