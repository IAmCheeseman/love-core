local path = (...):gsub(".asset_loader$", "")
local json = require(path .. ".thirdparty.json")
local newSprite = require(path .. ".types.sprite")

local assetLoader = {}

local function openJson(filePath)
  local contents = love.filesystem.read(filePath)
  return json.decode(contents)
end

local loaders = {
  png = love.graphics.newImage,
  jpg = love.graphics.newImage,

  ase = newSprite,

  fs = love.graphics.newShader,
  vs = love.graphics.newShader,

  mp3 = love.audio.newSource,
  ogg = love.audio.newSource,
  wav = love.audio.newSource,

  ttf = love.filesystem.newFileData,

  txt = love.filesystem.read,
  json = openJson,
}

local function loadAsset(filePath)
  for extension, v in pairs(loaders) do
    local fullPath = filePath .. "." .. extension
    local info = love.filesystem.getInfo(fullPath)
    if info then
      return v(fullPath)
    end
  end

  local info = love.filesystem.getInfo(filePath)
  if info then
    if info.type == "directory" then
      return assetLoader.load(filePath)
    end
  end

  return nil
end

local assetDirMt = {
  __index = function(t, k)
    if not rawget(t, k) then
      local asset = loadAsset(rawget(t, 1) .. "/" .. k)
      rawset(t, k, asset)
      return asset
    end
    return rawget(t, k)
  end,
  __newindex = function(_, _, _)
    error("Asset table is readonly!")
  end
}

function assetLoader.load(dirPath)
  dirPath = dirPath or ""
  local files = love.filesystem.getDirectoryItems(dirPath)

  local directory = {}

  for _, fileName in ipairs(files) do
    local filePath = dirPath .. "/" .. fileName
    local info = love.filesystem.getInfo(filePath)
    if info then
      if info.type == "directory" then
        directory[fileName] = assetLoader.load(filePath)
      end
    end
  end

  rawset(directory, 1, dirPath)
  return setmetatable(directory, assetDirMt)
end

function assetLoader.loadScripts(dirPath)
  local files = love.filesystem.getDirectoryItems(dirPath)

  for _, fileName in ipairs(files) do
    local filePath = dirPath .. "/" .. fileName
    local info = love.filesystem.getInfo(filePath)
    if info then
      if info.type == "file" then
        if fileName:gmatch(".lua$") then
          require(filePath:gsub(".lua$", ""))
        end
      elseif info.type == "directory" then
        assetLoader.loadScripts(filePath)
      end
    end
  end
end

return assetLoader
