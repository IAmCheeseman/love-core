local path = (...):gsub(".ui.vertical_renderer", "")
local theme = require(path .. ".ui.theme")

local verticalRenderer = {}
verticalRenderer.__index = verticalRenderer

function verticalRenderer:add(element)
  table.insert(self.elements, element)
end

function verticalRenderer:getTransform(element)
    local w, h
    if element.props.text then
      w = element.props.width or theme.font:getWidth(element.props.text) + self.elementPaddingW
      h = element.props.height or theme.font:getHeight() + self.elementPaddingH
    else
      w = element.props.width or element.props.width or 32
      h = element.props.height or element.props.height or 16
    end

    local x = self.x

    if self.center then
      x = x + (self.width - w) / 2
    elseif self.width then
      w = self.width
    end

    return x, w, h
end

function verticalRenderer:render()
  assert(not (self.center and not self.width),
      "Must define width if you want to center")

  local y = self.y
  for _, element in ipairs(self.elements) do
    local x, w, h = self:getTransform(element)
    element:render(x, y, w, h)
    y = y + h + self.separation
  end
end

local function newVerticalRenderer(x, y)
  local renderer = setmetatable({
    x = x, y = y,
    elementPaddingW = 3,
    elementPaddingH = 1,
    separation = 2,
    elements = {},
  }, verticalRenderer)

  return renderer
end

return newVerticalRenderer
