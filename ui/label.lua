local path = (...):gsub(".ui.label$", "")
local inky = require(path .. ".thirdparty.inky")
local theme = require(path .. ".ui.theme")

local label = inky.defineElement(function(self)
  self.props.align = "left"

  return function(_, x, y, w, h)
    love.graphics.setFont(theme.font)
    love.graphics.setColor(theme.fgColor)
    love.graphics.printf(
        self.props.text,
        x, y + (h - theme.font:getHeight()) / 2,
        w, self.props.align)
  end
end)

return label
