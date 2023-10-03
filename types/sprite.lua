local path = (...):gsub(".types.sprite$", "")
local loadAse = require(path .. ".thirdparty.lovease")

local IMAGE_CHUNK = 0x2005
local TAG_CHUNK = 0x2018

local sprite = {}
sprite.__index = sprite

local function Sprite(path)
  local file = loadAse(path)

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

function sprite:update(dt)
  if self.currentAnimation then
    local tag = self.tags[self.currentAnimation]

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
      x, y, rotation, scalex, scaley)
end

return Sprite
